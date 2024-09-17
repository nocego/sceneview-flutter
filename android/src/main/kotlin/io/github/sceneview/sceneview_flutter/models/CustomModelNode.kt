package io.github.sceneview.sceneview_flutter.models

import io.github.sceneview.node.ModelNode
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.math.Position

class CustomModelNode(
    modelInstance: ModelInstance,
    autoAnimate: Boolean = true,
    scaleToUnits: Float? = null,
    var centerOrigin: Position? = null
) : ModelNode(modelInstance, autoAnimate, scaleToUnits, centerOrigin) {
    var isTappable: Boolean = false
}