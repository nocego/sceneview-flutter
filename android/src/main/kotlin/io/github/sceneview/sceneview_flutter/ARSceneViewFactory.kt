package io.github.sceneview.sceneview_flutter

import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.lifecycle.Lifecycle
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.github.sceneview.sceneview_flutter.models.ARSceneViewConfig
class ARSceneViewFactory(
    private val activity: Activity,
    private val messenger: BinaryMessenger,
    private val lifecycle: Lifecycle
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.i("ARSceneViewFactory", "Creating SceneViewWrapper with id: $viewId")

        val params = args as? Map<String, Any> ?: emptyMap()

        val arConfig = params["arSceneviewConfig"]?.let { ARSceneViewConfig.from(it as Map<String, Any>) }
            ?: ARSceneViewConfig.default()

        val augmentedImages = params["augmentedImages"]?.let {
            Convert.toAugmentedImages(context, it as List<Map<String, Any>>)
        } ?: emptyList()

        return SceneViewWrapper(context, activity, lifecycle, messenger, viewId, arConfig, augmentedImages)
    }
}