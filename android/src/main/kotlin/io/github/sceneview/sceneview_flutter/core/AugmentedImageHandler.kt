package io.github.sceneview.sceneview_flutter.handlers

import android.content.Context
import android.util.Log
import com.google.ar.core.AugmentedImage
import com.google.ar.core.TrackingState
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.sceneview_flutter.models.FlutterReferenceNode
import io.github.sceneview.sceneview_flutter.utils.Constants
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONObject
import org.json.JSONArray
import com.google.ar.core.Pose
import io.github.sceneview.math.Position
import dev.romainguy.kotlin.math.Float3
import io.github.sceneview.sceneview_flutter.models.CustomModelNode as ModelNode

class AugmentedImageHandler(
    private val context: Context,
    private val sceneView: ARSceneView,
    private val eventHandler: EventHandler,
    private val nodeHandler: NodeHandler,
    private val coroutineScope: CoroutineScope,
    private val augmentedImageModels: Map<String, String>
) {
    private val trackedImages = mutableMapOf<String, Boolean>()
    private val detectionCounters = mutableMapOf<String, Int>()
    private val imageNodes = mutableMapOf<String, MutableList<ModelNode>>()
    private var initialAngleZ: Float? = null;

    suspend fun handleUpdatedAugmentedImages(updatedAugmentedImages: Collection<AugmentedImage>) {
        updatedAugmentedImages.forEach { augmentedImage ->
            if (augmentedImage.trackingState == TrackingState.TRACKING) {
                val isVisible = augmentedImage.trackingMethod == AugmentedImage.TrackingMethod.FULL_TRACKING
                if (isVisible) {
                    if (trackedImages[augmentedImage.name] == false) {
                        val counter = detectionCounters.getOrDefault(augmentedImage.name, 0) + 1
                        detectionCounters[augmentedImage.name] = counter

                        if (counter >= 50) {
                            trackedImages[augmentedImage.name] = true
                            placeObject(augmentedImage)
                            detectionCounters[augmentedImage.name] =
                                0 // Reset counter after placing the object
                        }
                    } else {
                        // Update the position and rotation of the node if it is already tracked
                        imageNodes[augmentedImage.name]?.let { nodes: MutableList<ModelNode> ->
                            for (node in nodes) {
                                val translation = augmentedImage.centerPose.translation
                                node.position =
                                    Position(Float3(translation[0], translation[1], translation[2]))

                                val rotation = FloatArray(4)
                                val pose = augmentedImage.centerPose
                                pose.getRotationQuaternion(rotation, 0)
                                rotation[1] += initialAngleZ!! / 10
                                node.rotation =
                                    Float3(rotation[0] * 100, rotation[1] * 100, rotation[2] * 100)
                            }

                        }
                    }
                } else {
                    var nodesToRemove: MutableList<ModelNode>? = imageNodes[augmentedImage.name]
                    if (nodesToRemove != null) {
                        for (node in nodesToRemove) {
                            nodeHandler.removeNode(node)
                        }
                    }
//                    nodeHandler.removeNode(imageNodes[augmentedImage.name])
                    trackedImages[augmentedImage.name] = false
                }
            } else if (trackedImages[augmentedImage.name] == null) {
                Log.w("AugmentedImageHandler", "Detected image not in tracking list: ${augmentedImage.name}")
            }
        }
    }

    private suspend fun placeObject(augmentedImage: AugmentedImage) {
        coroutineScope.launch(Dispatchers.Main) {
            val modelsArray = JSONArray(augmentedImageModels[augmentedImage.name])
            for (i in 0 until modelsArray.length()) {
                val modelString: String = modelsArray[i] as String
                val modelObject = JSONObject(modelString)
                val modelPath = modelObject.getString("path")
                var scaleX: Float? = null
                var scaleY: Float? = null
                var scaleZ: Float? = null
                val tempScaleX: Double = modelObject.optDouble("scaleX", Double.NaN)
                val tempScaleY: Double = modelObject.optDouble("scaleY", Double.NaN)
                val tempScaleZ: Double = modelObject.optDouble("scaleZ", Double.NaN)
                if (tempScaleX.isNaN()) {
                    scaleX = null
                } else {
                    scaleX = tempScaleX.toFloat()
                }
                if (tempScaleY.isNaN()) {
                    scaleY = null
                } else {
                    scaleY = tempScaleY.toFloat()
                }
                if (tempScaleZ.isNaN()) {
                    scaleZ = null
                } else {
                    scaleZ = tempScaleZ.toFloat()
                }
                val positionXRelative = modelObject.getDouble("positionXRelative").toFloat()
                val positionYRelative = modelObject.getDouble("positionYRelative").toFloat()
                val positionZRelative = modelObject.getDouble("positionZRelative").toFloat()
                val isTappable = modelObject.getBoolean("isTappable")

                if (modelPath == null) {
                    Log.e("AugmentedImageHandler", "No model found for image: ${augmentedImage.name}")
                    return@launch
                }

                var scale: Array<Float?>? = arrayOf(scaleX, scaleY, scaleZ)
                if (scaleX == null || scaleY == null || scaleZ == null) {
                    scale = null
                }

                var positionRelativeToImage: Array<Float?>? = arrayOf(positionXRelative, positionYRelative, positionZRelative)

                val rotation = applyRotationCorrection(augmentedImage)

                val flutterNode = FlutterReferenceNode(
                    id = augmentedImage.name,
                    position = augmentedImage.centerPose.translation,
                    rotation = rotation,
                    fileLocation = modelPath,
                    scale = scale,
                    positionRelativeToImage = positionRelativeToImage,
                    isTappable = isTappable
                )

                val node: ModelNode? = nodeHandler.addNode(flutterNode)
                if (node != null) {
                    eventHandler.sendEvent(Constants.EVENT_OBJECT_PLACED, augmentedImage.name)
                    Log.d("AugmentedImageHandler", "3D object placed for image: ${augmentedImage.name}")

                    // Store the node in the imageNodes map
                    if (imageNodes.containsKey(augmentedImage.name)) {
                        imageNodes[augmentedImage.name]?.add(node)
                    } else {
                        imageNodes[augmentedImage.name] = mutableListOf(node)
                    }
                } else {
                    Log.e("AugmentedImageHandler", "Failed to place 3D object for image: ${augmentedImage.name}")
                }
            }
        }.join() // Await the completion of the coroutine
    }

    private fun applyRotationCorrection(augmentedImage: AugmentedImage): FloatArray {
        val pose = augmentedImage.centerPose
        val correctedRotation = FloatArray(4)

        // Extract the quaternion from the pose
        pose.getRotationQuaternion(correctedRotation, 0)

        // Calculate the initial angle
        val initialAngleZ = Math.atan2(pose.zAxis[0].toDouble(), pose.zAxis[2].toDouble()).toFloat()
        this.initialAngleZ = initialAngleZ
        correctedRotation[1] += initialAngleZ/10

        correctedRotation[0] = correctedRotation[0] * 100f
        correctedRotation[1] = correctedRotation[1] * 100f
        correctedRotation[2] = correctedRotation[2] * 100f

        return correctedRotation
    }

    fun addAugmentedImageToTrack(imageName: String) {
        trackedImages[imageName] = false
    }
}