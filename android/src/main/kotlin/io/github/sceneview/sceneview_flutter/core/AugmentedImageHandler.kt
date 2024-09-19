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

class AugmentedImageHandler(
    private val context: Context,
    private val sceneView: ARSceneView,
    private val eventHandler: EventHandler,
    private val nodeHandler: NodeHandler,
    private val coroutineScope: CoroutineScope,
    private val augmentedImageModels: Map<String, String>
) {
    private val trackedImages = mutableMapOf<String, Boolean>()
    private val lastUpdatedTime = mutableMapOf<String, Long>()
    private val detectionCounters = mutableMapOf<String, Int>()
    private val updateInterval = 1000L // 1 second

    fun handleUpdatedAugmentedImages(updatedAugmentedImages: Collection<AugmentedImage>) {
        val currentTime = System.currentTimeMillis()
        updatedAugmentedImages.forEach { augmentedImage ->
            val isTracked = trackedImages[augmentedImage.name]
            val lastUpdateTime = lastUpdatedTime[augmentedImage.name] ?: 0L

            if (augmentedImage.trackingState == TrackingState.TRACKING) {
                if (isTracked == false && (currentTime - lastUpdateTime > updateInterval)) {
                    val counter = detectionCounters.getOrDefault(augmentedImage.name, 0) + 1
                    detectionCounters[augmentedImage.name] = counter

                    if (counter >= 50) {
                        placeObject(augmentedImage, augmentedImage.centerPose.rotationQuaternion)
                        lastUpdatedTime[augmentedImage.name] = currentTime
                        detectionCounters[augmentedImage.name] = 0 // Reset counter after placing the object
                    }
                }
            } else if (isTracked == null) {
                Log.w("AugmentedImageHandler", "Detected image not in tracking list: ${augmentedImage.name}")
            }
        }
    }

    private fun placeObject(augmentedImage: AugmentedImage, rotation: FloatArray) {
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

                val correctedRotation = applyRotationCorrection(augmentedImage, rotation)

                val flutterNode = FlutterReferenceNode(
                    id = augmentedImage.name,
                    position = augmentedImage.centerPose.translation,
                    rotation = correctedRotation,
                    fileLocation = modelPath,
                    scale = scale,
                    positionRelativeToImage = positionRelativeToImage,
                    isTappable = isTappable
                )

                val success = nodeHandler.addNode(flutterNode)
                if (success) {
                    trackedImages[augmentedImage.name] = true
                    eventHandler.sendEvent(Constants.EVENT_OBJECT_PLACED, augmentedImage.name)
                    Log.d("AugmentedImageHandler", "3D object placed for image: ${augmentedImage.name}")
                } else {
                    Log.e("AugmentedImageHandler", "Failed to place 3D object for image: ${augmentedImage.name}")
                }
            }
        }
    }

    private fun applyRotationCorrection(augmentedImage: AugmentedImage, rotation: FloatArray): FloatArray {
        val pose = augmentedImage.centerPose
        val correctedRotation = FloatArray(4)

        // Extract the quaternion from the pose
        pose.getRotationQuaternion(correctedRotation, 0)

        // Apply the correction to the input rotation
        correctedRotation[0] += rotation[0]
        correctedRotation[1] += rotation[1]
        correctedRotation[2] += rotation[2]
        correctedRotation[3] += rotation[3]

        return correctedRotation
    }

    fun addAugmentedImageToTrack(imageName: String) {
        trackedImages[imageName] = false
    }
}