package io.github.sceneview.sceneview_flutter.models

data class PlaneRenderer(
    val isEnabled: Boolean,
    val isVisible: Boolean
) {
    companion object {
        fun from(map: Map<String, Any>): PlaneRenderer {
            return PlaneRenderer(
                isEnabled = map["isEnabled"] as? Boolean ?: true,
                isVisible = map["isVisible"] as? Boolean ?: true
            )
        }
    }

    override fun toString(): String {
        return "PlaneRenderer(isVisible=$isVisible, isEnabled=$isEnabled)"
    }
}