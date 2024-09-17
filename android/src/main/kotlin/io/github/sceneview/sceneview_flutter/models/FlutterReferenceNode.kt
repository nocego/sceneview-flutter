// Path: io.github.sceneview.sceneview_flutter/models/FlutterReferenceNode.kt

package io.github.sceneview.sceneview_flutter.models

import android.util.Log
import dev.romainguy.kotlin.math.Float3

data class FlutterReferenceNode(
    val id: String,
    override val position: FloatArray,
    override val rotation: FloatArray,
    override val scale: Array<Float?>? = null,
    val fileLocation: String
) : FlutterSceneViewNode() {

    fun getPositionFloat3(): Float3 = Float3(position[0], position[1], position[2])
    fun getRotationFloat3(): Float3 = Float3(rotation[0], rotation[1], rotation[2])

    companion object {
        fun from(map: Map<String, *>): FlutterReferenceNode {
            Log.d("FlutterReferenceNode", "Creating node from map: $map")
            val positionMap = map["position"] as Map<String, Double>
            val rotationMap = map["rotation"] as Map<String, Double>
            val scaleMap = map["scale"] as Map<String, Double>
            val node = FlutterReferenceNode(
                id = map["id"] as String,
                position = floatArrayOf(
                    positionMap["x"]?.toFloat() ?: 0f,
                    positionMap["y"]?.toFloat() ?: 0f,
                    positionMap["z"]?.toFloat() ?: 0f
                ),
                rotation = floatArrayOf(
                    rotationMap["x"]?.toFloat() ?: 0f,
                    rotationMap["y"]?.toFloat() ?: 0f,
                    rotationMap["z"]?.toFloat() ?: 0f,
                    rotationMap["w"]?.toFloat() ?: 1f
                ),
                scale = arrayOf(
                    scaleMap["x"]?.toFloat() ?: null,
                    scaleMap["y"]?.toFloat() ?: null,
                    scaleMap["z"]?.toFloat() ?: null
                ),
                fileLocation = map["fileLocation"] as String
            )
            Log.d("FlutterReferenceNode", "Created node: $node")
            return node
        }
    }
}