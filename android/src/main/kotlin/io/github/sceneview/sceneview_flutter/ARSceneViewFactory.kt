package io.github.sceneview.sceneview_flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.lifecycle.Lifecycle
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.github.sceneview.sceneview_flutter.core.ARSceneViewConfig
import io.github.sceneview.sceneview_flutter.utils.Convert
import com.google.ar.core.Config

class ARSceneViewFactory(
    private val activity: Activity,
    private val messenger: BinaryMessenger,
    private val lifecycle: Lifecycle
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.i("ARSceneViewFactory", "Creating SceneViewWrapper with id: $viewId")
        val params = args as? Map<String, Any> ?: emptyMap()

        val builder = SceneViewBuilder().apply {
            augmentedImages = params["augmentedImages"]?.let {
                Log.d("ARSceneViewFactory", "Received augmented images: $it")
                Convert.toAugmentedImages(context, it as List<Map<String, Any>>)
            } ?: emptyList()

            config = ARSceneViewConfig(
                planeRendererEnabled = params["planeRendererEnabled"] as? Boolean ?: true,
                planeRendererVisible = params["planeRendererVisible"] as? Boolean ?: true,
                lightEstimationMode = Convert.toLightEstimationMode(params["lightEstimationMode"] as? Int) ?: Config.LightEstimationMode.AMBIENT_INTENSITY,
                depthMode = Convert.toDepthMode(params["depthMode"] as? Int) ?: Config.DepthMode.AUTOMATIC,
                instantPlacementMode = Convert.toInstantPlacementMode(params["instantPlacementMode"] as? Int) ?: Config.InstantPlacementMode.DISABLED
            )
        }

        return builder.build(context, activity, messenger, lifecycle, viewId)
    }
}