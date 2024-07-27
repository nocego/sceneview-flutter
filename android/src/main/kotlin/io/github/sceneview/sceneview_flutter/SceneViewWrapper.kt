package io.github.sceneview.sceneview_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.View
import android.widget.FrameLayout
import androidx.lifecycle.Lifecycle
import com.google.ar.core.Config
import kotlin.math.atan2
import com.google.ar.core.Plane
import com.google.ar.core.TrackingState
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.ar.arcore.addAugmentedImage
import io.github.sceneview.ar.arcore.getUpdatedPlanes
import io.github.sceneview.math.Position
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.node.ModelNode
import io.github.sceneview.node.Node
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import io.github.sceneview.sceneview_flutter.models.ARSceneViewConfig
import io.github.sceneview.sceneview_flutter.models.SceneViewAugmentedImage
import io.github.sceneview.sceneview_flutter.models.FlutterSceneViewNode
import io.github.sceneview.sceneview_flutter.models.FlutterReferenceNode
import io.github.sceneview.sceneview_flutter.models.FlutterPose
import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion
import dev.romainguy.kotlin.math.degrees
import kotlinx.coroutines.cancel

class SceneViewWrapper(
    private val context: Context,
    private val activity: Activity,
    private val lifecycle: Lifecycle,
    messenger: BinaryMessenger,
    id: Int,
    private val arConfig: ARSceneViewConfig,
    private val augmentedImages: List<SceneViewAugmentedImage>
) : PlatformView, MethodChannel.MethodCallHandler, EventChannel.StreamHandler, View.OnTouchListener {

    private var sceneView: ARSceneView? = null
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private val methodChannelName = "${Constants.CHANNEL_NAME_PREFIX}_$id"
    private val methodChannel = MethodChannel(messenger, methodChannelName)
    private val eventChannelName = "${Constants.CHANNEL_NAME_PREFIX}/events_$id"
    private val eventChannel = EventChannel(messenger, eventChannelName)
    private var eventSink: EventChannel.EventSink? = null
    private var isSceneViewInitialized = false
    private var selectedNode: ModelNode? = null
    private var isDragging = false
    private lateinit var gestureDetector: GestureDetector
    private var lastTouchX: Float = 0f
    private var lastTouchY: Float = 0f
    private var isRotating = false
    private var previousAngle = 0f

    init {
        Log.i(Constants.TAG, "Initializing SceneViewWrapper with id: $id")
        methodChannel.setMethodCallHandler(this)
        eventChannel.setStreamHandler(this)
        gestureDetector = GestureDetector(context, GestureListener())
        initializeARSceneView()
    }

    private fun initializeARSceneView() {
        if (isSceneViewInitialized) {
            Log.i(Constants.TAG, "ARSceneView is already initialized. Skipping initialization.")
            return
        }

        Log.i(Constants.TAG, "Initializing ARSceneView")
        try {
            sceneView = ARSceneView(context = context, sharedLifecycle = lifecycle)
            isSceneViewInitialized = true

            sceneView?.apply {
                configureSceneView()
                setupSessionCallbacks()
                setupLayoutParams()
                setOnTouchListener(this@SceneViewWrapper)
            }
            Log.i(Constants.TAG, "ARSceneView initialized")
        } catch (e: Exception) {
            Log.e(Constants.TAG, "Error initializing ARSceneView", e)
            sendEvent("onInitializationFailed", e.message)
        }
    }

    private fun ARSceneView.configureSceneView() {
        planeRenderer.isEnabled = arConfig.planeRenderer.isEnabled
        planeRenderer.isVisible = arConfig.planeRenderer.isVisible

        environment = environmentLoader.createHDREnvironment(
            assetFileLocation = "environments/studio_small_09_2k.hdr"
        )!!

        configureSession { session, config ->
            augmentedImages.forEach {
                Log.i(Constants.TAG, "Adding augmented image: ${it.name}")
                config.addAugmentedImage(session, it.name, it.bitmap)
            }

            config.lightEstimationMode = arConfig.lightEstimationMode
            config.depthMode = if (session.isDepthModeSupported(arConfig.depthMode)) {
                arConfig.depthMode
            } else {
                Config.DepthMode.DISABLED
            }
            config.instantPlacementMode = arConfig.instantPlacementMode
            config.focusMode = Config.FocusMode.AUTO
        }

        Log.i(Constants.TAG, "Session configured")
    }

    private fun ARSceneView.setupSessionCallbacks() {
        onSessionUpdated = { _, frame ->
            try {
                val updatedPlanes = frame.getUpdatedPlanes().map { plane ->
                    hashMapOf(
                        "type" to plane.type.ordinal,
                        "centerPose" to FlutterPose.fromPose(plane.centerPose).toHashMap()
                    )
                }
                val sessionUpdateMap = hashMapOf("planes" to updatedPlanes)
                sendEvent("onSessionUpdated", sessionUpdateMap)
            } catch (e: Exception) {
                Log.e(Constants.TAG, "Error in onSessionUpdated", e)
            }
        }

        onSessionCreated = {
            Log.i(Constants.TAG, "Session created")
            sendEvent("onSessionCreated", null)
        }

        onSessionResumed = {
            Log.i(Constants.TAG, "Session resumed")
            sendEvent("onSessionResumed", null)
        }

        onSessionPaused = {
            Log.i(Constants.TAG, "Session paused")
            sendEvent("onSessionPaused", null)
        }

        onSessionFailed = { exception ->
            Log.e(Constants.TAG, "Session failed", exception)
            sendEvent("onSessionFailed", exception.message)
        }

        onTrackingFailureChanged = { reason ->
            Log.i(Constants.TAG, "Tracking failure changed: $reason")
            sendEvent("onTrackingFailureChanged", reason?.ordinal)
        }
    }

    private fun ARSceneView.setupLayoutParams() {
        layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        keepScreenOn = true
    }

    override fun getView(): View {
        return sceneView ?: FrameLayout(context).also {
            Log.w(Constants.TAG, "SceneView not initialized, returning empty FrameLayout")
        }
    }

    override fun onTouch(v: View?, event: MotionEvent?): Boolean {
        event?.let { motionEvent ->
            when (motionEvent.actionMasked) {
                MotionEvent.ACTION_DOWN, MotionEvent.ACTION_POINTER_DOWN -> {
                    if (motionEvent.pointerCount == 2) {
                        // Two fingers down, start rotation
                        isRotating = true
                        isDragging = false  // Disable dragging when rotating
                        previousAngle = getTwoFingerAngle(motionEvent)
                    } else {
                        // Single finger down
                        lastTouchX = motionEvent.x
                        lastTouchY = motionEvent.y
                    }
                }
                MotionEvent.ACTION_MOVE -> {
                    if (isRotating && motionEvent.pointerCount == 2) {
                        // Handle two-finger rotation
                        val currentAngle = getTwoFingerAngle(motionEvent)
                        val angleDiff = currentAngle - previousAngle

                        // Add a minimum threshold for rotation
                        if (Math.abs(angleDiff) > 1.0f) {  // Adjust this threshold as needed
                            handleRotation(angleDiff)
                            previousAngle = currentAngle
                        }
                    } else if (isDragging && !isRotating) {
                        // Only handle drag if we're not rotating
                        handleDrag(lastTouchX, lastTouchY, motionEvent.x, motionEvent.y)
                        lastTouchX = motionEvent.x
                        lastTouchY = motionEvent.y
                    }
                }
                MotionEvent.ACTION_UP, MotionEvent.ACTION_POINTER_UP, MotionEvent.ACTION_CANCEL -> {
                    when (motionEvent.pointerCount) {
                        0 -> {
                            // All fingers up
                            isRotating = false
                            isDragging = false
                            selectedNode = null
                            lastTouchX = 0f
                            lastTouchY = 0f
                        }
                        1 -> {
                            // One finger left, stop rotating but allow dragging
                            isRotating = false
                            // Don't set isDragging here, let it be set by long press
                        }
                    }
                }
            }
        }
        return gestureDetector.onTouchEvent(event ?: return false)
    }

    private inner class GestureListener : GestureDetector.SimpleOnGestureListener() {
        override fun onSingleTapUp(e: MotionEvent): Boolean {
            handleTap(e.x, e.y)
            return true
        }

        override fun onLongPress(e: MotionEvent) {
            if (!isRotating) {  // Only start dragging if we're not rotating
                handleLongPress(e.x, e.y)
            }
        }

        override fun onScroll(e1: MotionEvent?, e2: MotionEvent, distanceX: Float, distanceY: Float): Boolean {
            if (isDragging && !isRotating && selectedNode != null) {
                handleDrag(e1?.x ?: 0f, e1?.y ?: 0f, e2.x, e2.y)
            }
            return true
        }
    }

    private fun handleLongPress(x: Float, y: Float) {
        if (!isRotating) {  // Only start dragging if we're not rotating
            sceneView?.let { view ->
                val hitNode = view.collisionSystem.hitTest(xPx = x, yPx = y).firstOrNull { it.node is ModelNode }
                if (hitNode != null) {
                    selectedNode = hitNode.node as ModelNode
                    isDragging = true
                    Log.d(Constants.TAG, "Long press on node: ${selectedNode?.name}")
                }
            }
        }
    }

    private fun handleDrag(startX: Float, startY: Float, endX: Float, endY: Float) {
        val sceneView = sceneView ?: return
        val frame = sceneView.session?.update() ?: return

        selectedNode?.let { node ->
            val startHit = frame.hitTest(startX, startY).firstOrNull()
            val endHit = frame.hitTest(endX, endY).firstOrNull()

            if (startHit != null && endHit != null) {
                val startPose = startHit.hitPose
                val endPose = endHit.hitPose

                val deltaX = endPose.tx() - startPose.tx()
                val deltaY = endPose.ty() - startPose.ty()
                val deltaZ = endPose.tz() - startPose.tz()

                node.position += Position(deltaX, deltaY, deltaZ)

                Log.d(Constants.TAG, "Dragging node: ${node.name} by ($deltaX, $deltaY, $deltaZ)")
                sendEvent("onNodeDrag", mapOf(
                    "nodeId" to node.name,
                    "position" to mapOf(
                        "x" to node.worldPosition.x,
                        "y" to node.worldPosition.y,
                        "z" to node.worldPosition.z
                    )
                ))
            }
        }
    }

    private fun handleTap(x: Float, y: Float) {
        sceneView?.let { view ->
            val frame = view.session?.update() ?: return
            if (frame.camera.trackingState != TrackingState.TRACKING) return

            val hits = frame.hitTest(x, y)

            for (hit in hits) {
                // First, check for ModelNode hits
                val hitNode = view.collisionSystem.hitTest(xPx = x, yPx = y).firstOrNull { it.node is ModelNode }
                if (hitNode != null) {
                    val modelNode = findModelNodeAncestor(hitNode.node)
                    if (modelNode != null) {
                        Log.d(Constants.TAG, "Node tapped: ${modelNode.name}")
                        // ModelNode hit, handle it and return
                        val worldPosition = modelNode.worldPosition
                        sendEvent("onNodeTap", mapOf(
                            "nodeId" to modelNode.name,
                            "position" to mapOf(
                                "x" to worldPosition.x,
                                "y" to worldPosition.y,
                                "z" to worldPosition.z
                            )
                        ))
                        return  // Exit after handling the node tap
                    }
                }

                // If no ModelNode hit, check for Plane hits
                if (hit.trackable is Plane) {
                    val hitPose = hit.hitPose
                    val hitPlane = hit.trackable as Plane
                    sendEvent("onPlaneTap", mapOf(
                        "planeType" to hitPlane.type.ordinal,
                        "pose" to FlutterPose.fromPose(hitPose).toHashMap()
                    ))
                    return  // Exit after handling the plane tap
                }
            }
        }
    }

    private fun getTwoFingerAngle(event: MotionEvent): Float {
        val (finger1X, finger1Y) = event.getX(0) to event.getY(0)
        val (finger2X, finger2Y) = event.getX(1) to event.getY(1)
        return Math.toDegrees(atan2((finger2Y - finger1Y).toDouble(), (finger2X - finger1X).toDouble())).toFloat()
    }

    private fun handleRotation(angleDiff: Float) {
        selectedNode?.let { node ->
            // Apply damping factor to reduce sensitivity
            val rotationDampingFactor = 0.01f
            val dampedAngleDiff = -angleDiff * rotationDampingFactor

            // Rotate around the Y-axis (vertical axis)
            val rotationDelta = Quaternion.fromAxisAngle(Float3(y = 1.0f), degrees(dampedAngleDiff))
            node.quaternion = node.quaternion * rotationDelta

            Log.d(Constants.TAG, "Rotating node: ${node.name} by $dampedAngleDiff degrees")
            sendEvent("onNodeRotate", mapOf(
                "nodeId" to node.name,
                "rotation" to mapOf(
                    "x" to node.rotation.x,
                    "y" to node.rotation.y,
                    "z" to node.rotation.z
                ),
                "quaternion" to mapOf(
                    "x" to node.quaternion.x,
                    "y" to node.quaternion.y,
                    "z" to node.quaternion.z,
                    "w" to node.quaternion.w
                )
            ))
        }
    }

    private fun findModelNodeAncestor(node: Node?): ModelNode? {
        var currentNode = node
        while (currentNode != null) {
            if (currentNode is ModelNode) {
                return currentNode
            }
            currentNode = currentNode.parent
        }
        return null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "addNode" -> {
                Log.e(Constants.TAG, "adding node")
                val nodeData = call.arguments as Map<String, *>
                val nodeType = nodeData["type"] as String
                val flutterNode = when (nodeType) {
                    "reference" -> FlutterReferenceNode.from(nodeData)
                    else -> throw IllegalArgumentException("Unknown node type: $nodeType")
                }
                mainScope.launch { addNode(flutterNode) }
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private suspend fun addNode(flutterNode: FlutterSceneViewNode) {
        sceneView?.let { view ->
            buildNode(flutterNode)?.let { node ->
                view.addChildNode(node)
                Log.d(Constants.TAG, "Node added successfully")
            }
        } ?: Log.e(Constants.TAG, "Cannot add node: SceneView not initialized")
    }

    private suspend fun buildNode(flutterNode: FlutterSceneViewNode): ModelNode? {
        return when (flutterNode) {
            is FlutterReferenceNode -> buildReferenceNode(flutterNode)
            else -> {
                Log.e(Constants.TAG, "Unsupported node type: ${flutterNode::class.simpleName}")
                null
            }
        }
    }

    private suspend fun buildReferenceNode(flutterNode: FlutterReferenceNode): ModelNode? {
        val fileLocation = Utils.getFlutterAssetKey(activity, flutterNode.fileLocation)
        Log.d(Constants.TAG, "Building node from file: $fileLocation")
        val model: ModelInstance? = sceneView?.modelLoader?.loadModelInstance(fileLocation)
        return if (model != null) {
            ModelNode(modelInstance = model, scaleToUnits = 1.0f).apply {
                position = flutterNode.position
                rotation = flutterNode.rotation
                name = flutterNode.id
                isPositionEditable = true
                isRotationEditable = true
                isScaleEditable = true
            }
        } else {
            Log.e(Constants.TAG, "Failed to load model from: $fileLocation")
            null
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun sendEvent(eventName: String, data: Any?) {
        eventSink?.success(mapOf("event" to eventName, "data" to data))
    }

    override fun dispose() {
        // Dispose of the ARSceneView
        sceneView?.let { view ->
            view.destroy()
            view.removeCallbacks(null)
        }
        sceneView = null

        // Clean up MethodChannel
        methodChannel.setMethodCallHandler(null)

        // Clean up EventChannel
        eventChannel.setStreamHandler(null)
        eventSink = null

        // Clean up coroutines
        mainScope.cancel()

        // Clean up GestureDetector
        gestureDetector.setOnDoubleTapListener(null)
        gestureDetector.setIsLongpressEnabled(false)

        // Reset all state variables
        isSceneViewInitialized = false
        selectedNode = null
        isDragging = false
        isRotating = false
        lastTouchX = 0f
        lastTouchY = 0f
        previousAngle = 0f

        // If you have any other resources (e.g., bitmaps, custom views), dispose of them here

        Log.i(Constants.TAG, "SceneViewWrapper disposed")
    }
}
