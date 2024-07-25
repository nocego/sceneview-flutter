package io.github.sceneview.sceneview_flutter.models

import com.google.ar.core.Config

data class ARSceneViewConfig(
    val planeRenderer: PlaneRendererConfig = PlaneRendererConfig(),
    val lightEstimationMode: Config.LightEstimationMode = Config.LightEstimationMode.ENVIRONMENTAL_HDR,
    val depthMode: Config.DepthMode = Config.DepthMode.AUTOMATIC,
    val instantPlacementMode: Config.InstantPlacementMode = Config.InstantPlacementMode.LOCAL_Y_UP
) {
    data class PlaneRendererConfig(
        val isEnabled: Boolean = true,
        val isVisible: Boolean = true
    )

    companion object {
        fun from(map: Map<String, Any>): ARSceneViewConfig {
            val planeRendererMap = map["planeRenderer"] as? Map<String, Any> ?: emptyMap()
            return ARSceneViewConfig(
                planeRenderer = PlaneRendererConfig(
                    isEnabled = planeRendererMap["isEnabled"] as? Boolean ?: true,
                    isVisible = planeRendererMap["isVisible"] as? Boolean ?: true
                ),
                lightEstimationMode = (map["lightEstimationMode"] as? Int)?.let {
                    Config.LightEstimationMode.values()[it]
                } ?: Config.LightEstimationMode.ENVIRONMENTAL_HDR,
                depthMode = (map["depthMode"] as? Int)?.let {
                    Config.DepthMode.values()[it]
                } ?: Config.DepthMode.AUTOMATIC,
                instantPlacementMode = (map["instantPlacementMode"] as? Int)?.let {
                    Config.InstantPlacementMode.values()[it]
                } ?: Config.InstantPlacementMode.LOCAL_Y_UP
            )
        }

        fun default() = ARSceneViewConfig()
    }
}