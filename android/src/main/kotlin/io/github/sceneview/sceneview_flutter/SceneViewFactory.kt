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

class SceneViewFactory(
    private val activity: Activity?,
    private val messenger: BinaryMessenger,
    private val lifecycle: Lifecycle?
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    private var pendingSceneViewWrapper: SceneViewWrapper? = null

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("SceneViewFactory", "Creating new view instance")
        val params = args as? Map<String, Any> ?: emptyMap()
        val arConfig = params["arSceneviewConfig"]?.let { ARSceneViewConfig.from(it as Map<String, Any>) }
            ?: ARSceneViewConfig.default()
        val augmentedImages = params["augmentedImages"]?.let {
            Convert.toAugmentedImages(context, it as List<Map<String, Any>>)
        } ?: emptyList()

        return activity?.let { act ->
            lifecycle?.let { life ->
                SceneViewWrapper(context, act, life, messenger, viewId, arConfig, augmentedImages).also {
                    pendingSceneViewWrapper = it
                }
            }
        } ?: throw IllegalStateException("Activity or Lifecycle is null")
    }

    fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        if (requestCode == SceneViewWrapper.CAMERA_PERMISSION_CODE) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                pendingSceneViewWrapper?.initializeARSceneView()
            } else {
                Log.e("SceneViewFactory", "Camera permission denied")
                // Handle permission denial (e.g., show a message to the user)
            }
            pendingSceneViewWrapper = null
        }
    }
}