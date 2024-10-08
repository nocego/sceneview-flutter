package io.github.sceneview.sceneview_flutter.models

sealed class FlutterSceneViewNode {
    abstract val position: FloatArray
    abstract val rotation: FloatArray
    abstract val scale: Array<Float?>?
    abstract val positionRelativeToImage: Array<Float?>?
    abstract val isTappable: Boolean

    companion object {
        fun from(map: Map<String, *>): FlutterSceneViewNode {
            return when (map["type"] as? String) {
                "reference" -> FlutterReferenceNode.from(map)
                else -> throw IllegalArgumentException("Unknown node type")
            }
        }
    }
}