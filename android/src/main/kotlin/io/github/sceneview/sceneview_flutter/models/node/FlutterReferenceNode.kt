package io.github.sceneview.sceneview_flutter.models.node

import dev.romainguy.kotlin.math.Float3
import dev.romainguy.kotlin.math.Quaternion

class FlutterReferenceNode(
    val fileLocation: String,
    position: Float3,
    rotation: Quaternion,
    scale: Float3,
    scaleUnits: Float
) : FlutterSceneViewNode(position, rotation, scale, scaleUnits)