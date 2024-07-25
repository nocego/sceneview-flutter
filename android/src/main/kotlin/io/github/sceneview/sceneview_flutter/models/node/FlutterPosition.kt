package io.github.sceneview.sceneview_flutter.models.node

import dev.romainguy.kotlin.math.Float3

class FlutterPosition(val position: Float3) {
    companion object {
        fun from(list: List<Float>?): FlutterPosition {
            if (list == null) {
                return FlutterPosition(Float3(0f, 0f, 0f))
            }
            val x = (list[0] as Double).toFloat()
            val y = (list[1] as Double).toFloat()
            val z = (list[2] as Double).toFloat()
            return FlutterPosition(Float3(x, y, z))
        }
    }
}