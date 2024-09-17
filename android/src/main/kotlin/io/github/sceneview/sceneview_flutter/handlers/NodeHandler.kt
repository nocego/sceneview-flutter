// Path: io.github.sceneview.sceneview_flutter/handlers/NodeHandler.kt

package io.github.sceneview.sceneview_flutter.handlers

import android.app.Activity
import android.util.Log
import io.github.sceneview.ar.ARSceneView
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.sceneview_flutter.models.CustomModelNode as ModelNode
import io.github.sceneview.sceneview_flutter.models.FlutterReferenceNode
import io.github.sceneview.sceneview_flutter.models.FlutterSceneViewNode
import io.github.sceneview.sceneview_flutter.utils.Constants
import io.github.sceneview.sceneview_flutter.utils.Utils
import dev.romainguy.kotlin.math.Float3
import io.github.sceneview.math.Position

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
                name = flutterNode.id
                isPositionEditable = true
                isRotationEditable = true
                isScaleEditable = true
            }
            if (flutterNode.scale == null || flutterNode.scale[0] == null || flutterNode.scale[1] == null || flutterNode.scale[2] == null) {
                Log.d(Constants.TAG, "Scale is null")
            } else {
                node.scale = Float3(flutterNode.scale[0]!!, flutterNode.scale[1]!!, flutterNode.scale[2]!!)
            }
            if (flutterNode.positionRelativeToImage == null) {
                Log.d(Constants.TAG, "PositionRelativeToImage is null")
            } else {
                var tempPosition = flutterNode.getPositionFloat3()
                Log.d(Constants.TAG, "tempPosition")
                Log.d(Constants.TAG, tempPosition.toString())
                Log.d(Constants.TAG, tempPosition.x.toString())
                tempPosition.x = tempPosition.x + flutterNode.positionRelativeToImage[0]!!
                tempPosition.y = tempPosition.y + flutterNode.positionRelativeToImage[1]!!
                tempPosition.z = tempPosition.z + flutterNode.positionRelativeToImage[2]!!
                Log.d(Constants.TAG, tempPosition.x.toString())
                node.position = tempPosition
            }
            if (flutterNode.isTappable) {
                node.isTappable = true
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