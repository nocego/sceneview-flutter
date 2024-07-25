package io.github.sceneview.sceneview_flutter.models

import dev.romainguy.kotlin.math.Float3

sealed class FlutterSceneViewNode {
    abstract val position: Float3
    abstract val rotation: Float3

    companion object {
        fun from(map: Map<String, *>): FlutterSceneViewNode {
            return when (map["type"] as? String) {
                "reference" -> FlutterReferenceNode.from(map)
                else -> throw IllegalArgumentException("Unknown node type")
            }
        }
    }
}