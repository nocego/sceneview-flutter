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

class AugmentedImageHandler(
    private val context: Context,
    private val sceneView: ARSceneView,
    private val eventHandler: EventHandler,
    private val nodeHandler: NodeHandler,
    private val coroutineScope: CoroutineScope,
    private val augmentedImageModels: Map<String, String>
) {
    private val trackedImages = mutableMapOf<String, Boolean>()

    fun handleUpdatedAugmentedImages(updatedAugmentedImages: Collection<AugmentedImage>) {
        updatedAugmentedImages.forEach { augmentedImage ->
            val isTracked = trackedImages[augmentedImage.name]
            if (augmentedImage.trackingState == TrackingState.TRACKING) {
                if (isTracked == false) {
                    placeObject(augmentedImage)
                }
            } else if (isTracked == null) {
                Log.w("AugmentedImageHandler", "Detected image not in tracking list: ${augmentedImage.name}")
            }
        }
    }

    private fun placeObject(augmentedImage: AugmentedImage) {
        coroutineScope.launch(Dispatchers.Main) {
            val modelObject = JSONObject(augmentedImageModels[augmentedImage.name])
            val modelPath = modelObject.getString("path")
            val scaleX = modelObject.getDouble("scaleX").toFloat()
            val scaleY = modelObject.getDouble("scaleY").toFloat()
            val scaleZ = modelObject.getDouble("scaleZ").toFloat()

            if (modelPath == null) {
                Log.e("AugmentedImageHandler", "No model found for image: ${augmentedImage.name}")
                return@launch
            }

            var scale: Array<Float?>? = arrayOf(scaleX, scaleY, scaleZ)
            if (scaleX == null || scaleY == null || scaleZ == null) {
                scale = null
            }

            val flutterNode = FlutterReferenceNode(
                id = augmentedImage.name,
                position = augmentedImage.centerPose.translation,
                rotation = augmentedImage.centerPose.rotationQuaternion,
                fileLocation = modelPath,
                scale = scale
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

    fun addAugmentedImageToTrack(imageName: String) {
        trackedImages[imageName] = false
    }
}