package io.github.sceneview.sceneview_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.lifecycle.Lifecycle
import io.flutter.plugin.common.BinaryMessenger
import io.github.sceneview.sceneview_flutter.core.SceneViewWrapper
import io.github.sceneview.sceneview_flutter.core.ARSceneViewConfig
import io.github.sceneview.sceneview_flutter.models.SceneViewAugmentedImage

class SceneViewBuilder {
    var augmentedImages = listOf<SceneViewAugmentedImage>()
    var augmentedImageModels = mapOf<String, String>()
    lateinit var config: ARSceneViewConfig

    fun setAugmentedImages(images: List<SceneViewAugmentedImage>): SceneViewBuilder {
        augmentedImages = images
        return this
    }

    fun setAugmentedImageModels(models: Map<String, String>): SceneViewBuilder {
        augmentedImageModels = models
        return this
    }

    fun setConfig(arConfig: ARSceneViewConfig): SceneViewBuilder {
        config = arConfig
        return this
    }

    fun build(
        context: Context,
        activity: Activity,
        messenger: BinaryMessenger,
        lifecycle: Lifecycle,
        viewId: Int
    ): SceneViewWrapper {
        if (!::config.isInitialized) {
            throw IllegalStateException("ARSceneViewConfig must be set before building")
        }

        Log.i("SceneViewBuilder", "Building SceneViewWrapper with config: $config")
        return SceneViewWrapper(
            context,
            activity,
            lifecycle,
            messenger,
            viewId,
            config,
            augmentedImages,
            augmentedImageModels
        ).also {
            Log.i("SceneViewBuilder", "SceneViewWrapper built successfully")
            // Additional initialization if needed
        }
    }
}