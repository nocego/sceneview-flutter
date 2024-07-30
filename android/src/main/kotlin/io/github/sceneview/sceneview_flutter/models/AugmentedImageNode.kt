package io.github.sceneview.sceneview_flutter.models

import com.google.android.filament.Engine
import com.google.ar.core.AugmentedImage
import io.github.sceneview.ar.node.AugmentedImageNode
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.node.ModelNode

class SceneViewAugmentedImageNode(
    engine: Engine,
    augmentedImage: AugmentedImage
) : AugmentedImageNode(engine, augmentedImage) {

    var modelNode: ModelNode? = null

    fun updateModelNode(modelInstance: ModelInstance) {
        modelNode?.let { removeChildNode(it) }
        modelNode = ModelNode(modelInstance = modelInstance, scaleToUnits = augmentedImage.extentX).apply {
            isPositionEditable = true
            isRotationEditable = true
            isScaleEditable = true
        }
        addChildNode(modelNode!!)
    }
}