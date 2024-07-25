package io.github.sceneview.sceneview_flutter.models.node

import dev.romainguy.kotlin.math.Float3

class FlutterScale(val scale: Float3) {
    companion object {
        fun from(list: List<Float>?): FlutterScale {
            if (list == null) {
                return FlutterScale(Float3(0f, 0f, 0f))
            }
            val x = (list[0] as Double).toFloat()
            val y = (list[1] as Double).toFloat()
            val z = (list[2] as Double).toFloat()
            return FlutterScale(Float3(x, y, z))
        }
    }
}