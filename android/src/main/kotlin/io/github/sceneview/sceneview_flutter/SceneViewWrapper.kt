package io.github.sceneview.sceneview_flutter

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import android.view.View
import android.widget.FrameLayout
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import com.google.ar.core.Config
import dev.romainguy.kotlin.math.Float3
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.ar.arcore.addAugmentedImage
import io.github.sceneview.ar.arcore.getUpdatedPlanes
import io.github.sceneview.ar.node.AugmentedImageNode
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.node.ModelNode
import io.github.sceneview.sceneview_flutter.flutter_models.FlutterPose
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SceneViewWrapper(
    private val context: Context,
    private val activity: Activity,
    private val lifecycle: Lifecycle,
    messenger: BinaryMessenger,
    id: Int,
    private val arConfig: ARSceneViewConfig,
    private val augmentedImages: List<SceneViewAugmentedImage>
) : PlatformView, MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "SceneViewWrapper"
        const val CAMERA_PERMISSION_CODE = 100
    }

    private var sceneView: ARSceneView? = null
    private val mainScope = CoroutineScope(Dispatchers.Main)
    private val methodChannel = MethodChannel(messenger, "scene_view_$id")

    init {
        Log.i(TAG, "Initializing SceneViewWrapper")
        Log.i(TAG, "Number of augmented images: ${augmentedImages.size}")
        methodChannel.setMethodCallHandler(this)
        checkCameraPermissionAndInitialize()
    }

    private fun checkCameraPermissionAndInitialize() {
        if (ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED) {
            initializeARSceneView()
        } else {
            requestCameraPermission()
        }
    }

    private fun requestCameraPermission() {
        ActivityCompat.requestPermissions(activity, arrayOf(Manifest.permission.CAMERA), CAMERA_PERMISSION_CODE)
    }

    fun initializeARSceneView() {
        sceneView = ARSceneView(context = context, sharedLifecycle = lifecycle).apply {
            planeRenderer.isEnabled = arConfig.planeRenderer.isEnabled
            planeRenderer.isVisible = arConfig.planeRenderer.isVisible

            configureSession { session, config ->
                augmentedImages.forEach { config.addAugmentedImage(session, it.name, it.bitmap) }
                config.lightEstimationMode = arConfig.lightEstimationMode
                config.depthMode = if (session.isDepthModeSupported(arConfig.depthMode)) {
                    arConfig.depthMode
                } else {
                    Config.DepthMode.DISABLED
                }
                config.instantPlacementMode = arConfig.instantPlacementMode
            }

            setupSessionCallbacks()
        }
    }

    private fun ARSceneView.setupSessionCallbacks() {
        onSessionUpdated = { _, frame ->
            val updatedPlanes = frame.getUpdatedPlanes().map { plane ->
                hashMapOf(
                    "type" to plane.type.ordinal,
                    "centerPose" to FlutterPose.fromPose(plane.centerPose).toHashMap()
                )
            }
            val sessionUpdateMap = hashMapOf("planes" to updatedPlanes)
            Log.i(TAG, "Session updated: $sessionUpdateMap")
            methodChannel.invokeMethod("onSessionUpdated", sessionUpdateMap)
        }

        onSessionResumed = { Log.i(TAG, "Session resumed") }
        onSessionFailed = { exception -> Log.e(TAG, "Session failed: $exception") }
        onSessionCreated = { Log.i(TAG, "Session created") }
        onTrackingFailureChanged = { reason ->
            Log.i(TAG, "Tracking failure changed: $reason")
            methodChannel.invokeMethod("onTrackingFailureChanged", reason?.ordinal)
        }
    }

    override fun getView(): View {
        Log.i(TAG, "Getting SceneView")
        return sceneView ?: FrameLayout(context).also {
            Log.w(TAG, "SceneView not initialized, returning empty FrameLayout")
        }
    }

    override fun dispose() {
        Log.i(TAG, "Disposing SceneViewWrapper")
        sceneView = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "init" -> {
                Log.i(TAG, "Initializing from method channel")
                checkCameraPermissionAndInitialize()
                result.success(null)
            }
            "addNode" -> {
                Log.i(TAG, "Adding node")
                val flutterNode = FlutterSceneViewNode.from(call.arguments as Map<String, *>)
                mainScope.launch { addNode(flutterNode) }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private suspend fun addNode(flutterNode: FlutterSceneViewNode) {
        sceneView?.let { view ->
            buildNode(flutterNode)?.let { node ->
                view.addChildNode(node)
                Log.d(TAG, "Node added successfully")
            }
        } ?: Log.e(TAG, "Cannot add node: SceneView not initialized")
    }

    private suspend fun buildNode(flutterNode: FlutterSceneViewNode): ModelNode? {
        when (flutterNode) {
            is FlutterReferenceNode -> {
                val fileLocation = Utils.getFlutterAssetKey(activity, flutterNode.fileLocation)
                Log.d(TAG, "Building node from file: $fileLocation")
                val model: ModelInstance? = sceneView?.modelLoader?.loadModelInstance(fileLocation)
                return if (model != null) {
                    ModelNode(modelInstance = model, scaleToUnits = 1.0f).apply {
                        transform(
                            position = flutterNode.position,
                            rotation = Float3(
                                flutterNode.rotation.x,
                                flutterNode.rotation.y,
                                flutterNode.rotation.z
                            )
                        )
                    }
                } else {
                    Log.e(TAG, "Failed to load model from: $fileLocation")
                    null
                }
            }

            else -> {
                Log.e(TAG, "Unsupported node type: ${flutterNode::class.simpleName}")
                return null
            }
        }
    }
}