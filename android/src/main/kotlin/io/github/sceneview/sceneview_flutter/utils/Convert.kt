package io.github.sceneview.sceneview_flutter

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import io.github.sceneview.sceneview_flutter.models.SceneViewAugmentedImage
import io.github.sceneview.sceneview_flutter.utils.Utils
import java.io.IOException

object Convert {
    private const val TAG = "Convert"

    fun toAugmentedImages(
        context: Context,
        list: List<Map<String, Any>>
    ): List<SceneViewAugmentedImage> {
        val output = mutableListOf<SceneViewAugmentedImage>()


        list.forEachIndexed { index, map ->
            try {
                val name = map["name"] as? String
                val assetLocation = map["assetLocation"] as? String

                if (name == null || assetLocation == null) {
                    Log.e(TAG, "Invalid augmented image data at index $index: $map")
                    return@forEachIndexed
                }

                val assetKey = Utils.getFlutterAssetKey(context, assetLocation)
                val bitmap = loadBitmapFromAsset(context, assetKey)

                if (bitmap != null) {
                    val augmentedImage = SceneViewAugmentedImage(name, bitmap)
                    output.add(augmentedImage)
                    Log.d(TAG, "Added augmented image: $name")
                } else {
                    Log.e(TAG, "Failed to load bitmap for augmented image: $name")
                }
            } catch (ex: Exception) {
                Log.e(TAG, "Error processing augmented image at index $index", ex)
            }
        }
        Log.i(TAG, "Processed ${output.size} augmented images")
        return output
    }

    private fun loadBitmapFromAsset(context: Context, assetKey: String): Bitmap? {
        return try {
            context.assets.open(assetKey).use { inputStream ->
                BitmapFactory.decodeStream(inputStream)
            }
        } catch (e: IOException) {
            Log.e(TAG, "Error loading bitmap from asset: $assetKey", e)
            null
        }
    }
}