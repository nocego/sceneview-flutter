package io.github.sceneview.sceneview_flutter.models

import dev.romainguy.kotlin.math.Float3

data class FlutterReferenceNode(
    override val position: Float3,
    override val rotation: Float3,
    val fileLocation: String
) : FlutterSceneViewNode() {
    companion object {
        fun from(map: Map<String, *>): FlutterReferenceNode {
            val positionMap = map["position"] as Map<String, Double>
            val rotationMap = map["rotation"] as Map<String, Double>
            return FlutterReferenceNode(
                position = Float3(
                    positionMap["x"]?.toFloat() ?: 0f,
                    positionMap["y"]?.toFloat() ?: 0f,
                    positionMap["z"]?.toFloat() ?: 0f
                ),
                rotation = Float3(
                    rotationMap["x"]?.toFloat() ?: 0f,
                    rotationMap["y"]?.toFloat() ?: 0f,
                    rotationMap["z"]?.toFloat() ?: 0f
                ),
                fileLocation = map["fileLocation"] as String
            )
        }
    }
}