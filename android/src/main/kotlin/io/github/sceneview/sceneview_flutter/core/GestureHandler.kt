package io.github.sceneview.sceneview_flutter.handlers

import android.util.Log
import android.view.GestureDetector
import android.view.MotionEvent
import android.view.View
import com.google.ar.core.Plane
import com.google.ar.core.TrackingState
import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion
import dev.romainguy.kotlin.math.degrees
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.math.Position
import io.github.sceneview.node.ModelNode
import io.github.sceneview.node.Node
import io.github.sceneview.sceneview_flutter.models.FlutterPose
import io.github.sceneview.sceneview_flutter.utils.Constants
import kotlinx.coroutines.CoroutineScope
import kotlin.math.atan2

class GestureHandler(
    private val sceneView: ARSceneView?,
    private val eventHandler: EventHandler
) : View.OnTouchListener {

    private val gestureDetector: GestureDetector
    private var selectedNode: ModelNode? = null
    private var isDragging = false
    private var isRotating = false
    private var lastTouchX = 0f
    private var lastTouchY = 0f
    private var previousAngle = 0f

    init {
        gestureDetector = GestureDetector(sceneView?.context, GestureListener())
    }

    override fun onTouch(v: View?, event: MotionEvent?): Boolean {
        event?.let { motionEvent ->
            when (motionEvent.actionMasked) {
                MotionEvent.ACTION_DOWN, MotionEvent.ACTION_POINTER_DOWN -> handleActionDown(motionEvent)
                MotionEvent.ACTION_MOVE -> handleActionMove(motionEvent)
                MotionEvent.ACTION_UP, MotionEvent.ACTION_POINTER_UP, MotionEvent.ACTION_CANCEL -> handleActionUp(motionEvent)
            }
        }
        return gestureDetector.onTouchEvent(event ?: return false)
    }

    private fun handleActionDown(event: MotionEvent) {
        if (event.pointerCount == 2) {
            isRotating = true
            isDragging = false
            previousAngle = getTwoFingerAngle(event)
        } else {
            lastTouchX = event.x
            lastTouchY = event.y
        }
    }

    private fun handleActionMove(event: MotionEvent) {
        if (isRotating && event.pointerCount == 2) {
            handleRotation(event)
        } else if (isDragging && !isRotating) {
            handleDrag(lastTouchX, lastTouchY, event.x, event.y)
            lastTouchX = event.x
            lastTouchY = event.y
        }
    }

    private fun handleActionUp(event: MotionEvent) {
        when (event.pointerCount) {
            0 -> {
                isRotating = false
                isDragging = false
                selectedNode = null
                lastTouchX = 0f
                lastTouchY = 0f
            }
            1 -> isRotating = false
        }
    }

    private fun handleRotation(event: MotionEvent) {
        val currentAngle = getTwoFingerAngle(event)
        val angleDiff = currentAngle - previousAngle
        if (Math.abs(angleDiff) > 1.0f) {
            rotateSelectedNode(angleDiff)
            previousAngle = currentAngle
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
                eventHandler.sendEvent("onNodeDrag", mapOf(
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

    private fun rotateSelectedNode(angleDiff: Float) {
        selectedNode?.let { node ->
            // Apply damping factor to reduce sensitivity
            val rotationDampingFactor = 0.01f
            val dampedAngleDiff = -angleDiff * rotationDampingFactor

            // Rotate around the Y-axis (vertical axis)
            val rotationDelta = Quaternion.fromAxisAngle(Float3(y = 1.0f), degrees(dampedAngleDiff))
            node.quaternion *= rotationDelta

            Log.d(Constants.TAG, "Rotating node: ${node.name} by $dampedAngleDiff degrees")
            eventHandler.sendEvent("onNodeRotate", mapOf(
                "nodeId" to node.name,
                "rotation" to mapOf(
                    "x" to node.worldRotation.x,
                    "y" to node.worldRotation.y,
                    "z" to node.worldRotation.z
                ),
                "quaternion" to mapOf(
                    "x" to node.worldQuaternion.x,
                    "y" to node.worldQuaternion.y,
                    "z" to node.worldQuaternion.z,
                    "w" to node.worldQuaternion.w
                )
            ))
        }
    }

    private fun getTwoFingerAngle(event: MotionEvent): Float {
        val (finger1X, finger1Y) = event.getX(0) to event.getY(0)
        val (finger2X, finger2Y) = event.getX(1) to event.getY(1)
        return Math.toDegrees(atan2((finger2Y - finger1Y).toDouble(), (finger2X - finger1X).toDouble())).toFloat()
    }

    private inner class GestureListener : GestureDetector.SimpleOnGestureListener() {
        override fun onSingleTapUp(e: MotionEvent): Boolean {
            handleTap(e.x, e.y)
            return true
        }

        override fun onLongPress(e: MotionEvent) {
            if (!isRotating) {
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
                        eventHandler.sendEvent("onNodeTap", mapOf(
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
                    eventHandler.sendEvent("onPlaneTap", mapOf(
                        "planeType" to hitPlane.type.ordinal,
                        "pose" to FlutterPose.fromPose(hitPose).toHashMap()
                    ))
                    return  // Exit after handling the plane tap
                }
            }
        }
    }

    private fun handleLongPress(x: Float, y: Float) {
        if (!isRotating) {
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
}