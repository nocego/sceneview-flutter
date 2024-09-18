package io.github.sceneview.sceneview_flutter.models

import android.graphics.Bitmap

data class SceneViewAugmentedImage(
    val name: String,
    val bitmap: Bitmap,
    val widthInMeters: Float
)