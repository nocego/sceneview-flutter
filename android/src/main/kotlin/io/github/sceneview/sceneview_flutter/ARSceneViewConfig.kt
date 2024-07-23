package io.github.sceneview.sceneview_flutter
import com.google.ar.core.Config
import android.util.Log

class ARSceneViewConfig(
    val lightEstimationMode: Config.LightEstimationMode,
    val instantPlacementMode: Config.InstantPlacementMode,
    val depthMode: Config.DepthMode,
    val planeRenderer: PlaneRenderer,
) {
    companion object {
        private const val TAG = "ARSceneViewConfig"

        fun default(): ARSceneViewConfig {
            return ARSceneViewConfig(
                lightEstimationMode = Config.LightEstimationMode.AMBIENT_INTENSITY,
                instantPlacementMode = Config.InstantPlacementMode.DISABLED,
                depthMode = Config.DepthMode.AUTOMATIC,
                planeRenderer = PlaneRenderer(isEnabled = true, isVisible = true)
            )
        }

        fun from(map: Map<String, Any>?): ARSceneViewConfig {
            if (map == null) {
                Log.e(TAG, "Input map is null")
                return default()
            }

            val lightEstimationMode = try {
                Config.LightEstimationMode.valueOf(map["lightEstimationMode"] as? String ?: "")
            } catch (e: IllegalArgumentException) {
                Log.e(TAG, "Invalid lightEstimationMode: ${map["lightEstimationMode"]}")
                Config.LightEstimationMode.AMBIENT_INTENSITY
            }

            val instantPlacementMode = try {
                Config.InstantPlacementMode.valueOf(map["instantPlacementMode"] as? String ?: "")
            } catch (e: IllegalArgumentException) {
                Log.e(TAG, "Invalid instantPlacementMode: ${map["instantPlacementMode"]}")
                Config.InstantPlacementMode.DISABLED
            }

            val depthMode = try {
                Config.DepthMode.valueOf(map["depthMode"] as? String ?: "")
            } catch (e: IllegalArgumentException) {
                Log.e(TAG, "Invalid depthMode: ${map["depthMode"]}")
                Config.DepthMode.AUTOMATIC
            }

            val planeRenderer = try {
                PlaneRenderer.from(map["planeRenderer"] as? Map<String, Any> ?: emptyMap())
            } catch (e: Exception) {
                Log.e(TAG, "Error creating PlaneRenderer: ${e.message}")
                PlaneRenderer(true, true)
            }

            return ARSceneViewConfig(
                lightEstimationMode,
                instantPlacementMode,
                depthMode,
                planeRenderer
            )
        }
    }

    override fun toString(): String {
        return "PlaneRenderer: $planeRenderer\n" +
                "instantPlacementMode: $instantPlacementMode\n" +
                "lightEstimationMode: $lightEstimationMode\n" +
                "depthMode: $depthMode\n"
    }
}