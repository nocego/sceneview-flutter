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
            val modelPath = augmentedImageModels[augmentedImage.name]
            if (modelPath == null) {
                Log.e("AugmentedImageHandler", "No model found for image: ${augmentedImage.name}")
                return@launch
            }

            val flutterNode = FlutterReferenceNode(
                id = augmentedImage.name,
                position = augmentedImage.centerPose.translation,
                rotation = augmentedImage.centerPose.rotationQuaternion,
                fileLocation = modelPath
            )

            val success = nodeHandler.addNode(flutterNode)
            if (success) {
                // Calculate the scale factor based on the size of the augmented image
                val scaleFactor = augmentedImage.extentX // or extentZ, depending on your model's orientation

                // Find the added node and set its scale
                val node = sceneView.findNodeByName(flutterNode.id) as? ModelNode
                node?.scale = Float3(scaleFactor, scaleFactor, scaleFactor)

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