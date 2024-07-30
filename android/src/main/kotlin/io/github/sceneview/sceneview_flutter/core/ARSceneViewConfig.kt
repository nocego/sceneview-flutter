package io.github.sceneview.sceneview_flutter.core

import android.util.Log
import com.google.ar.core.Config
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.ar.arcore.addAugmentedImage
import io.github.sceneview.sceneview_flutter.models.SceneViewAugmentedImage

class ARSceneViewConfig(
    val planeRendererEnabled: Boolean,
    val planeRendererVisible: Boolean,
    val lightEstimationMode: Config.LightEstimationMode,
    val depthMode: Config.DepthMode,
    val instantPlacementMode: Config.InstantPlacementMode
) {
    companion object {
        fun configureSceneView(
            sceneView: ARSceneView,
            config: ARSceneViewConfig,
            augmentedImages: List<SceneViewAugmentedImage>
        ) {
            sceneView.apply {
                Log.d("ARSceneViewConfig", "Configuring SceneView with config: $config")
                planeRenderer.isEnabled = config.planeRendererEnabled
                planeRenderer.isVisible = config.planeRendererVisible

                environment = environmentLoader.createHDREnvironment(
                    assetFileLocation = "environments/studio_small_09_2k.hdr"
                )!!

                configureSession { session, arConfig ->
                    Log.d("ARSceneViewConfig", "Configuring session with config: $config")

                    augmentedImages.forEach {
                        val widthInMeters = 0.1f // 10 cm, adjust as needed
                        arConfig.addAugmentedImage(session, it.name, it.bitmap, widthInMeters)
                    }

                    arConfig.lightEstimationMode = config.lightEstimationMode
                    arConfig.depthMode = if (session.isDepthModeSupported(config.depthMode)) {
                        config.depthMode
                    } else {
                        Config.DepthMode.DISABLED
                    }
                    arConfig.instantPlacementMode = config.instantPlacementMode
                    arConfig.focusMode = Config.FocusMode.AUTO
                }
            }
        }
    }
}