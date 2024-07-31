package io.github.sceneview.sceneview_flutter.models

import com.google.ar.core.Pose

data class FlutterPose(
    val translation: List<Float>,
    val rotation: List<Float>
) {
    fun toHashMap(): HashMap<String, Any> {
        return hashMapOf(
            "translation" to translation,
            "rotation" to rotation
        )
    }

    companion object {
        fun fromPose(pose: Pose): FlutterPose {
            return FlutterPose(
                translation = listOf(pose.tx(), pose.ty(), pose.tz()),
                rotation = listOf(pose.qx(), pose.qy(), pose.qz(), pose.qw())
            )
        }
    }
}