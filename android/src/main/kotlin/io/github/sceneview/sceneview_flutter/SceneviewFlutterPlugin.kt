package io.github.sceneview.sceneview_flutter

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.app.Activity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleOwner
import android.util.Log // Change this import

class SceneviewFlutterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var lifecycle: Lifecycle? = null

    companion object {
        private const val TAG = "SceneViewWrapper"
        private const val CHANNEL_NAME_PREFIX = "sceneview_flutter"
        private const val VIEW_TYPE = "SceneView" // Add this constant
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.i(TAG, "onAttachedToEngine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME_PREFIX)
        Log.i(TAG, "Setting method call handler for channel: $CHANNEL_NAME_PREFIX")
        channel.setMethodCallHandler(this)
        this.flutterPluginBinding = flutterPluginBinding
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.i(TAG, "Received method call: ${call.method}, for channel: $CHANNEL_NAME_PREFIX")
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        flutterPluginBinding = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(TAG, "Plugin attached to activity")
        activity = binding.activity
        if (activity is LifecycleOwner) {
            lifecycle = (activity as LifecycleOwner).lifecycle
            Log.d(TAG, "Lifecycle obtained from activity")
            registerViewFactory()
        } else {
            Log.e(TAG, "Activity is not a LifecycleOwner")
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        activity = null
        lifecycle = null
    }

    private fun registerViewFactory() {
        Log.d(TAG, "Attempting to register view factory")
        activity?.let { activity ->
            lifecycle?.let { lifecycle ->
                flutterPluginBinding?.let { binding ->
                    try {
                        binding.platformViewRegistry.registerViewFactory(
                            VIEW_TYPE,
                            ARSceneViewFactory(activity, binding.binaryMessenger, lifecycle)
                        )
                        Log.i(TAG, "Successfully registered ARSceneViewFactory")
                    } catch (e: Exception) {
                        Log.e(TAG, "Failed to register ARSceneViewFactory", e)
                    }
                } ?: Log.e(TAG, "FlutterPluginBinding is null")
            } ?: Log.e(TAG, "Lifecycle is null")
        } ?: Log.e(TAG, "Activity is null")
    }
}