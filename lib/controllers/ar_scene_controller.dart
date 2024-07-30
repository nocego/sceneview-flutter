import 'dart:async';
import 'package:sceneview_flutter/controllers/event_handler.dart';
import 'package:sceneview_flutter/controllers/node_manager.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import '../models/ar_hit_test_result.dart';
import '../models/plane.dart';
import '../models/plane_tap_event.dart';
import '../models/node_tap_event.dart';
import '../models/augmented_image.dart';
import '../enums/plane_type.dart';
import '../enums/tracking_failure_reason.dart';
import '../models/scene_node.dart';
import '../utils/channel_manager.dart';

class ARSceneController {
  final int id;
  late final ChannelManager _channelManager;
  late final EventHandler _eventHandler;
  late final NodeManager _nodeManager;
  bool _isInitialized = false;

  final StreamController<List<Plane>> planesController =
      StreamController<List<Plane>>.broadcast();
  final StreamController<PlaneTapEvent> planeTapController =
      StreamController<PlaneTapEvent>.broadcast();
  final StreamController<NodeTapEvent> nodeTapController =
      StreamController<NodeTapEvent>.broadcast();
  final StreamController<TrackingFailureReason> trackingFailureController =
      StreamController<TrackingFailureReason>.broadcast();
  final StreamController<List<AugmentedImage>> augmentedImagesController =
      StreamController<List<AugmentedImage>>.broadcast();

  Stream<List<Plane>> get planesStream => planesController.stream;
  Stream<PlaneTapEvent> get planeTapStream => planeTapController.stream;
  Stream<NodeTapEvent> get nodeTapStream => nodeTapController.stream;
  Stream<TrackingFailureReason> get trackingFailureStream =>
      trackingFailureController.stream;
  Stream<List<AugmentedImage>> get augmentedImagesStream =>
      augmentedImagesController.stream;

  ARSceneController(this.id) {
    _channelManager = ChannelManager(id);
    _eventHandler = EventHandler(_channelManager, this);
    _nodeManager = NodeManager(_channelManager);
  }
  Future<void> addNode(SceneNode node) async {
    final nodeData = {
      'type': 'reference',
      'id': node.id,
      'position': {
        'x': node.position.x,
        'y': node.position.y,
        'z': node.position.z,
      },
      'rotation': {
        'x': node.rotation.x,
        'y': node.rotation.y,
        'z': node.rotation.z,
        'w': node.rotation.w,
      },
      'scale': {
        'x': node.scale.x,
        'y': node.scale.y,
        'z': node.scale.z,
      },
      'fileLocation': node.fileLocation,
    };
    await _channelManager.invokeMethod('addNode', nodeData);
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      print("ARSceneController is already initialized.");
      return;
    }

    print("Initializing ARSceneController with id: $id");
    try {
      _eventHandler.setupEventChannel();
      _isInitialized = true;
    } catch (e) {
      print("Error initializing ARSceneController: $e");
      rethrow;
    }
  }

  Future<vector_math.Vector3?> getAugmentedImagePosition(
      String imageName) async {
    final result =
        await _channelManager.invokeMethod('getAugmentedImagePosition', {
      'imageName': imageName,
    });
    if (result != null) {
      return vector_math.Vector3(result['x'], result['y'], result['z']);
    }
    return null;
  }

  Future<List<Plane>> getPlanes() async {
    print("Getting planes");
    final List result = await _channelManager.invokeMethod('getPlanes');
    return result.map((e) => Plane.fromJson(e)).toList();
  }

  Future<ARHitTestResult?> performHitTest(double x, double y) async {
    print("Performing hit test at ($x, $y)");
    final result = await _channelManager.invokeMethod('performHitTest', {
      'x': x,
      'y': y,
    });
    if (result != null) {
      return ARHitTestResult(
        position: vector_math.Vector3(result['x'], result['y'], result['z']),
        planeType: PlaneType.values[result['planeType']],
      );
    }
    return null;
  }

  Future<void> setPlaneDetectionEnabled(bool enabled) async {
    print("Setting plane detection enabled: $enabled");
    await _channelManager
        .invokeMethod('setPlaneDetectionEnabled', {'enabled': enabled});
  }

  Future<void> setLightEstimationEnabled(bool enabled) async {
    print("Setting light estimation enabled: $enabled");
    await _channelManager
        .invokeMethod('setLightEstimationEnabled', {'enabled': enabled});
  }

  Future<void> dispose() async {
    print("Disposing ARSceneController with id: $id");
    await _channelManager.invokeMethod('dispose', {'viewId': id});
    await planesController.close();
    await planeTapController.close();
    await nodeTapController.close();
    await trackingFailureController.close();
    await augmentedImagesController.close();
  }
}
