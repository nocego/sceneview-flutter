import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';
import 'controllers/ar_scene_controller.dart';
import 'models/ar_scene_config.dart';
import 'models/scene_node.dart';
import 'models/augmented_image.dart';
import 'models/plane.dart' as customPlane;
import 'enums/tracking_failure_reason.dart';

class ARSceneView extends StatefulWidget {
  final ARSceneConfig config;

  final void Function(ARSceneController controller)? onViewCreated;
  final void Function(List<customPlane.Plane> planes)? onPlanesChanged;
  final void Function(customPlane.Plane plane, Vector3 position)? onPlaneTapped;
  final void Function(SceneNode node, Vector3 position)? onNodeTapped;
  final void Function(TrackingFailureReason reason)? onTrackingFailureChanged;
  final void Function(List<AugmentedImage> images)? onAugmentedImagesChanged;
  final List<AugmentedImage>? augmentedImages;
  final Map<String, String> augmentedImageModels;

  const ARSceneView({
    super.key,
    this.config = const ARSceneConfig(),
    this.onViewCreated,
    this.onPlanesChanged,
    this.onNodeTapped,
    this.onPlaneTapped,
    this.onTrackingFailureChanged,
    this.onAugmentedImagesChanged,
    this.augmentedImages,
    this.augmentedImageModels = const {},
  });

  @override
  _ARSceneViewState createState() => _ARSceneViewState();
}

class _ARSceneViewState extends State<ARSceneView> {
  late ARSceneController _controller;
  bool _isInitializing = true;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    const String viewType = 'SceneView';

    final Map<String, dynamic> creationParams = <String, dynamic>{
      'arSceneviewConfig': widget.config.toJson(),
      'augmentedImages':
          widget.augmentedImages?.map((e) => e.toJson()).toList(),
      'augmentedImageModels': widget.augmentedImageModels,
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
    print("Platform view created with id: $id");
    _controller = ARSceneController(id);
    _initializeController();
  }

  void _initializeController() async {
    print("Initializing controller");
    try {
      await _controller.initialize();

      _controller.planesStream.listen((planes) {
        widget.onPlanesChanged?.call(planes);
      });

      _controller.planeTapStream.listen((event) {
        widget.onPlaneTapped?.call(event.plane, event.position);
      });

      _controller.nodeTapStream.listen((event) {
        widget.onNodeTapped?.call(event.node, event.position);
      });

      _controller.trackingFailureStream.listen((reason) {
        widget.onTrackingFailureChanged?.call(reason);
      });

      _controller.augmentedImagesStream.listen((images) {
        for (var image in images) {
          if (image.isTracking) {
            _placeModelOnAugmentedImage(image);
          }
        }
        widget.onAugmentedImagesChanged?.call(images);
      });

      widget.onViewCreated?.call(_controller);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to initialize AR: $e';
      });
    } finally {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _placeModelOnAugmentedImage(AugmentedImage image) async {
    if (widget.augmentedImageModels.containsKey(image.name)) {
      final modelPath = widget.augmentedImageModels[image.name]!;
      final position = await _controller.getAugmentedImagePosition(image.name);
      if (position != null) {
        final node = SceneNode(
          id: 'model_${image.name}_${DateTime.now().millisecondsSinceEpoch}',
          position: position,
          rotation: Quaternion.identity(),
          scale: Vector3(0.1, 0.1, 0.1), // Adjust scale as needed
          fileLocation: modelPath,
        );
        await _controller.addNode(node);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
