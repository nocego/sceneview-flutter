// Path: io.github.sceneview.sceneview_flutter/handlers/NodeHandler.kt

package io.github.sceneview.sceneview_flutter.handlers

import android.app.Activity
import android.util.Log
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.node.ModelNode
import io.github.sceneview.sceneview_flutter.models.FlutterReferenceNode
import io.github.sceneview.sceneview_flutter.models.FlutterSceneViewNode
import io.github.sceneview.sceneview_flutter.utils.Constants
import io.github.sceneview.sceneview_flutter.utils.Utils

class NodeHandler(
    private val sceneView: ARSceneView,
    private val activity: Activity
) {
    suspend fun addNode(flutterNode: FlutterSceneViewNode): Boolean {
        return when (flutterNode) {
            is FlutterReferenceNode -> addReferenceNode(flutterNode)
            else -> {
                Log.e(Constants.TAG, "Unsupported node type: ${flutterNode::class.simpleName}")
                false
            }
        }
    }

    private suspend fun addReferenceNode(flutterNode: FlutterReferenceNode): Boolean {
        val fileLocation = Utils.getFlutterAssetKey(activity, flutterNode.fileLocation)
        Log.d(Constants.TAG, "Building node from file: $fileLocation")
        val model: ModelInstance? = sceneView.modelLoader.loadModelInstance(fileLocation)
        return if (model != null) {
            val node = ModelNode(modelInstance = model, scaleToUnits = 1.0f).apply {
                position = flutterNode.getPositionFloat3()
                rotation = flutterNode.getRotationFloat3()
                scale = flutterNode.getScaleFloat3() // Apply scale
                name = flutterNode.id
                isPositionEditable = true
                isRotationEditable = true
                isScaleEditable = true
            }
            sceneView.addChildNode(node)
            Log.d(Constants.TAG, "Node added successfully")
            true
        } else {
            Log.e(Constants.TAG, "Failed to load model from: $fileLocation")
            false
        }
    }
}