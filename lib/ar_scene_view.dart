import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';
import 'models/ar_scene_config.dart';
import 'models/scene_node.dart';
import 'models/augmented_image.dart';
import 'models/plane.dart' as customPlane;
import 'enums/tracking_failure_reason.dart';
import 'ar_scene_controller.dart';

class ARSceneView extends StatefulWidget {
  final ARSceneConfig config;
  final void Function(ARSceneController controller)? onViewCreated;
  final void Function(List<customPlane.Plane> planes)? onPlanesChanged;
  final void Function(SceneNode node, Vector3 position)? onNodeTapped;
  final void Function(TrackingFailureReason reason)? onTrackingFailureChanged;
  final void Function(List<AugmentedImage> images)? onAugmentedImagesChanged;
  final List<AugmentedImage>? augmentedImages;

  const ARSceneView({
    super.key,
    this.config = const ARSceneConfig(),
    this.onViewCreated,
    this.onPlanesChanged,
    this.onNodeTapped,
    this.onTrackingFailureChanged,
    this.onAugmentedImagesChanged,
    this.augmentedImages,
  });

  @override
  _ARSceneViewState createState() => _ARSceneViewState();
}

class _ARSceneViewState extends State<ARSceneView> {
  ARSceneController? _controller;

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = 'SceneView';

    final Map<String, dynamic> creationParams = <String, dynamic>{
      'arSceneviewConfig': widget.config.toJson(),
      'augmentedImages':
          widget.augmentedImages?.map((e) => e.toJson()).toList(),
    };

    return Platform.isAndroid
        ? AndroidView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          )
        : UiKitView(
            viewType: viewType,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: const StandardMessageCodec(),
            onPlatformViewCreated: _onPlatformViewCreated,
          );
  }

  void _onPlatformViewCreated(int id) {
    _controller = ARSceneController(id);
    _controller!.initialize();

    _controller!.planesStream.listen((planes) {
      widget.onPlanesChanged?.call(planes);
    });

    _controller!.nodeTapStream.listen((event) {
      widget.onNodeTapped?.call(event.node, event.position);
    });

    _controller!.trackingFailureStream.listen((reason) {
      widget.onTrackingFailureChanged?.call(reason);
    });

    _controller!.augmentedImagesStream.listen((images) {
      widget.onAugmentedImagesChanged?.call(images);
    });

    widget.onViewCreated?.call(_controller!);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

Vector3 vector3FromJson(List<dynamic> json) {
  return Vector3(
    (json[0] as num).toDouble(),
    (json[1] as num).toDouble(),
    (json[2] as num).toDouble(),
  );
}
