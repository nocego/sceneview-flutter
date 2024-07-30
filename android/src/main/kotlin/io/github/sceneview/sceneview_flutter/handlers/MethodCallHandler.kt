package io.github.sceneview.sceneview_flutter.handlers

import android.app.Activity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.sceneview_flutter.models.FlutterSceneViewNode
import io.github.sceneview.sceneview_flutter.utils.Constants
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch


class MethodCallHandler(
    private val sceneView: ARSceneView?,
    private val activity: Activity,
    id: Int,
    messenger: BinaryMessenger,
    private val coroutineScope: CoroutineScope
) : MethodChannel.MethodCallHandler {

    private val methodChannel: MethodChannel
    private val nodeHandler: NodeHandler?

    init {
        val methodChannelName = "${Constants.CHANNEL_NAME_PREFIX}_$id"
        methodChannel = MethodChannel(messenger, methodChannelName)
        methodChannel.setMethodCallHandler(this)
        nodeHandler = sceneView?.let { NodeHandler(it, activity) }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "addNode" -> handleAddNode(call, result)
            "dispose" -> handleDispose(result)
            else -> result.notImplemented()
        }
    }

    private fun handleAddNode(call: MethodCall, result: MethodChannel.Result) {
        val nodeData = call.arguments as? Map<String, *>
        nodeData?.let {
            val flutterNode = FlutterSceneViewNode.from(it)
            coroutineScope.launch {
                val success = nodeHandler?.addNode(flutterNode) ?: false
                result.success(success)
            }
        } ?: result.error("INVALID_ARGUMENT", "Invalid node data", null)
    }

    private fun handleDispose(result: MethodChannel.Result) {
        // Dispose logic here
        result.success(null)
    }

    fun dispose() {
        methodChannel.setMethodCallHandler(null)
    }
}