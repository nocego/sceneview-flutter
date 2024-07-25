package io.github.sceneview.sceneview_flutter.models.node

import dev.romainguy.kotlin.math.Quaternion

class FlutterRotation(val rotation: Quaternion) {
    companion object {
        fun from(list: List<Float>?): FlutterRotation {
            if (list == null) {
                return FlutterRotation(Quaternion(0f, 0f, 0f, 0f))
            }
            val x = (list[0] as Double).toFloat()
            val y = (list[1] as Double).toFloat()
            val z = (list[2] as Double).toFloat()
            val w = (list[3] as Double).toFloat()
            return FlutterRotation(Quaternion(x, y, z, w))
        }
    }
}