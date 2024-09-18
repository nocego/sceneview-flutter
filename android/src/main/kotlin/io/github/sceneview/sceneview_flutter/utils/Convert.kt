package io.github.sceneview.sceneview_flutter.utils

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Log
import com.google.ar.core.Config
import io.github.sceneview.sceneview_flutter.models.SceneViewAugmentedImage
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
                var widthInMetersDouble = map["widthInMeters"] as? Double
                val widthInMeters = widthInMetersDouble?.let { it.toFloat() }

                if (name == null || assetLocation == null) {
                    Log.e(TAG, "Invalid augmented image data at index $index: $map")
                    return@forEachIndexed
                }

                val assetKey = Utils.getFlutterAssetKey(context, assetLocation)
                val bitmap = loadBitmapFromAsset(context, assetKey)

                if (bitmap != null) {
                    val augmentedImage = SceneViewAugmentedImage(name, bitmap, widthInMeters ?: 0.1f)
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

    fun toLightEstimationMode(value: Int?): Config.LightEstimationMode {
        return when (value) {
            1 -> Config.LightEstimationMode.AMBIENT_INTENSITY
            2 -> Config.LightEstimationMode.ENVIRONMENTAL_HDR
            else -> Config.LightEstimationMode.DISABLED
        }
    }

    fun toDepthMode(value: Int?): Config.DepthMode {
        return when (value) {
            1 -> Config.DepthMode.AUTOMATIC
            2 -> Config.DepthMode.RAW_DEPTH_ONLY
            else -> Config.DepthMode.DISABLED
        }
    }

    fun toInstantPlacementMode(value: Int?): Config.InstantPlacementMode {
        return when (value) {
            1 -> Config.InstantPlacementMode.LOCAL_Y_UP
            else -> Config.InstantPlacementMode.DISABLED
        }
    }
}