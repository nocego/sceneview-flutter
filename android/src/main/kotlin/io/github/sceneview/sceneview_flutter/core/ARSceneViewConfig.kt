package io.github.sceneview.sceneview_flutter.core

import android.util.Log
import com.google.ar.core.Config
import com.google.ar.core.Session
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
                planeRenderer.isEnabled = false
                planeRenderer.isVisible = false
                environment = environmentLoader.createHDREnvironment(
                    assetFileLocation = "environments/studio_small_09_2k.hdr"
                )!!
            }
        }

        fun createSessionConfigurationCallback(
            config: ARSceneViewConfig,
            augmentedImages: List<SceneViewAugmentedImage>
        ): (Session, Config) -> Unit = { session, arConfig ->
            Log.d("ARSceneViewConfig", "Applying session config: $config")
            augmentedImages.forEach {
                arConfig.addAugmentedImage(session, it.name, it.bitmap, it.widthInMeters)
            }
            arConfig.lightEstimationMode = config.lightEstimationMode
            arConfig.depthMode = if (session.isDepthModeSupported(config.depthMode)) {
                config.depthMode
            } else {
                Config.DepthMode.DISABLED
            }
            arConfig.instantPlacementMode = config.instantPlacementMode
            arConfig.focusMode = Config.FocusMode.AUTO
            arConfig.updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
        }
    }
}