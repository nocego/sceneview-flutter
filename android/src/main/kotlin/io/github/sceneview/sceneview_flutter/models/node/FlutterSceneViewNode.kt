package io.github.sceneview.sceneview_flutter.models.node

import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion

abstract class FlutterSceneViewNode(
    val position: Float3 = Float3(0f, 0f, 0f),
    val rotation: Quaternion = Quaternion(0f, 0f, 0f),
    val scale: Float3 = Float3(0f, 0f, 0f),
    val scaleUnits: Float = 1.0f,
) {
    companion object {
        fun from(map: Map<String, *>): FlutterSceneViewNode {
            val fileLocation = map["fileLocation"] as String?
            if (fileLocation != null) {
                val p = FlutterPosition.from(map["position"] as List<Float>?)
                val r = FlutterRotation.from(map["rotation"] as List<Float>?)
                val s = FlutterScale.from(map["scale"] as List<Float>?)
                val scaleUnits = map["scaleUnits"] as Float?
                return FlutterReferenceNode(
                    fileLocation,
                    p.position,
                    r.rotation,
                    s.scale,
                    scaleUnits ?: 1.0f,
                )
            }
            throw Exception("Invalid node data")
        }
    }
}