import 'dart:async';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'enums/plane_type.dart';
import 'models/ar_hit_test_result.dart';
import 'models/pose.dart';
import 'models/scene_node.dart';
import 'models/plane.dart';
import 'models/augmented_image.dart';
import 'enums/tracking_failure_reason.dart';
import 'utils/constants.dart';
import 'utils/vector_converter.dart';

class NodeTapEvent {
  final SceneNode node;
  final vector_math.Vector3 position;

  NodeTapEvent(this.node, this.position);
}

class PlaneTapEvent {
  final Plane plane;
  final vector_math.Vector3 position;
  PlaneTapEvent(this.plane, this.position);
}

class ARSceneController {
  final int id;
  final MethodChannel _channel;
  final EventChannel _eventChannel;
  bool _isInitialized = false;

  final StreamController<List<Plane>> _planesController =
      StreamController<List<Plane>>.broadcast();

  final StreamController<PlaneTapEvent> _planeTapController =
      StreamController<PlaneTapEvent>.broadcast();

  final StreamController<NodeTapEvent> _nodeTapController =
      StreamController<NodeTapEvent>.broadcast();

  final StreamController<TrackingFailureReason> _trackingFailureController =
      StreamController<TrackingFailureReason>.broadcast();

  final StreamController<List<AugmentedImage>> _augmentedImagesController =
      StreamController<List<AugmentedImage>>.broadcast();

  Stream<List<Plane>> get planesStream => _planesController.stream;
  Stream<PlaneTapEvent> get planeTapStream => _planeTapController.stream;
  Stream<NodeTapEvent> get nodeTapStream => _nodeTapController.stream;
  Stream<TrackingFailureReason> get trackingFailureStream =>
      _trackingFailureController.stream;
  Stream<List<AugmentedImage>> get augmentedImagesStream =>
      _augmentedImagesController.stream;

  ARSceneController(this.id)
      : _channel = MethodChannel('${ARConstants.methodChannelName}_$id'),
        _eventChannel = EventChannel('${ARConstants.eventChannelName}_$id') {
    print("ARSceneController created with id: $id");
    print("Method channel name: ${_channel.name}");
    print("Event channel name: ${_eventChannel.name}");
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      print("ARSceneController is already initialized.");
      return;
    }

    print("Initializing ARSceneController with id: $id");
    try {
      print("Initialize method call completed");
      _setupEventChannel();
      _isInitialized = true;
    } catch (e) {
      print("Error initializing ARSceneController: $e");
      rethrow;
    }
  }

  void _setupEventChannel() {
    print("Setting up event channel listener");
    _eventChannel.receiveBroadcastStream().listen(
      (dynamic event) {
        print("Received event: $event");
        if (event is Map) {
          String eventName = event['event'] as String;
          dynamic data = event['data'];
          _handleEvent(eventName, data);
        } else {
          print("Unexpected event format: ${event.runtimeType}");
        }
      },
      onError: (dynamic error) {
        print("Error from event channel: $error");
      },
    );
  }

  void _handleEvent(String eventName, dynamic data) {
    print("Handling event: $eventName with data: $data");
    switch (eventName) {
      case 'onSessionUpdated':
        if (data is Map) {
          _handlePlanesChanged(data);
        }
        break;
      case 'onPlaneTap':
        if (data is Map) {
          _handlePlaneTapped(data);
        }
        break;
      case 'onNodeTap':
        if (data is Map) {
          _handleNodeTapped(data);
        }
        break;
      case 'onTrackingFailureChanged':
        if (data is int) {
          _handleTrackingFailureChanged(data);
        }
        break;
      case 'onAugmentedImagesChanged':
        if (data is Map) {
          _handleAugmentedImagesChanged(data);
        }
        break;
      case 'onSessionResumed':
        print("AR Session resumed");
        break;
      case 'onSessionFailed':
        print("AR Session failed: $data");
        break;
      case 'onSessionCreated':
        print("AR Session created");
        break;
      default:
        print("Unknown event type: $eventName");
    }
  }

  void _handlePlanesChanged(Map data) {
    final List<dynamic> planesList = data['planes'] as List<dynamic>;

    if (planesList.isEmpty) {
      _planesController.add([]);
      return;
    }
    final List<Plane> planes = planesList.asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;

      // Convert the map to Map<String, dynamic>
      final planeData = Map<String, dynamic>.from(e as Map);
      final centerPoseData =
          Map<String, dynamic>.from(planeData['centerPose'] as Map);

      final centerPose = Pose(
        translation: vector3FromList(
            (centerPoseData['translation'] as List).cast<double>()),
        rotation: vector_math.Quaternion(
          (centerPoseData['rotation'] as List)[0] as double,
          (centerPoseData['rotation'] as List)[1] as double,
          (centerPoseData['rotation'] as List)[2] as double,
          (centerPoseData['rotation'] as List)[3] as double,
        ),
      );

      final plane = Plane(
        type: PlaneType.values[planeData['type'] as int],
        centerPose: centerPose,
      );

      // Generate a unique ID for each plane
      return plane.copyWith(
          id: 'plane_${DateTime.now().millisecondsSinceEpoch}_${index}_${plane.type}');
    }).toList();

    _planesController.add(planes);
  }

  void _handlePlaneTapped(Map data) {
    try {
      final planeType = PlaneType.values[data['planeType'] as int];
      final poseData = Map<String, dynamic>.from(data['pose'] as Map);

      final translationList = poseData['translation'] as List<dynamic>;
      final rotationList = poseData['rotation'] as List<dynamic>;

      final translation = translationList.map((e) => e as double).toList();
      final rotation = rotationList.map((e) => e as double).toList();

      if (translation.length != 3) {
        throw const FormatException('Invalid translation format');
      }

      if (rotation.length != 4) {
        throw const FormatException('Invalid rotation format');
      }

      final plane = Plane(
        id: 'plane_${DateTime.now().millisecondsSinceEpoch}',
        type: planeType,
        centerPose: Pose(
          translation: vector3FromList(translation),
          rotation: vector_math.Quaternion(
            rotation[0],
            rotation[1],
            rotation[2],
            rotation[3],
          ),
        ),
      );

      final position = vector3FromList(translation);
      print("Plane tapped: ${plane.id} at $position");
      _planeTapController.add(PlaneTapEvent(plane, position));
    } catch (e) {
      print("Error handling plane tap event: $e");
    }
  }

  void _handleNodeTapped(Map data) {
    final nodeId = data['nodeId'] as String;

    final position = const Vector3MapConverter()
        .fromJson(data['position'] as Map<dynamic, dynamic>);

    final rotation = data.containsKey('rotation')
        ? const QuaternionMapConverter().fromJson(data['rotation'])
        : vector_math.Quaternion.identity();

    final scale = data.containsKey('scale')
        ? const Vector3MapConverter().fromJson(data['scale'])
        : vector_math.Vector3(0.5, 0.5, 0.5);

    final node = SceneNode(
      id: nodeId,
      position: position,
      rotation: rotation,
      scale: scale,
    );

    _nodeTapController.add(NodeTapEvent(node, position));
    print("NodeTapEvent added to controller");
  }

  void _handleTrackingFailureChanged(int data) {
    final reason = TrackingFailureReason.values[data];
    print("Tracking failure changed: $reason");
    _trackingFailureController.add(reason);
  }

  void _handleAugmentedImagesChanged(Map data) {
    final List<AugmentedImage> images = (data['images'] as List)
        .map((e) => AugmentedImage.fromJson(e))
        .toList();
    print("Augmented images changed: ${images.length} images");
    _augmentedImagesController.add(images);
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
    await _channel.invokeMethod('addNode', nodeData);
  }

  Future<void> removeNode(String nodeId) async {
    print("Removing node: $nodeId");
    await _channel.invokeMethod('removeNode', {'nodeId': nodeId});
  }

  Future<void> updateNode(SceneNode node) async {
    print("Updating node: ${node.id}");
    await _channel.invokeMethod('updateNode', node.toJson());
  }

  Future<List<Plane>> getPlanes() async {
    print("Getting planes");
    final List result = await _channel.invokeMethod('getPlanes');
    return result.map((e) => Plane.fromJson(e)).toList();
  }

  Future<ARHitTestResult?> performHitTest(double x, double y) async {
    print("Performing hit test at ($x, $y)");
    final result = await _channel.invokeMethod('performHitTest', {
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
    await _channel
        .invokeMethod('setPlaneDetectionEnabled', {'enabled': enabled});
  }

  Future<void> setLightEstimationEnabled(bool enabled) async {
    print("Setting light estimation enabled: $enabled");
    await _channel
        .invokeMethod('setLightEstimationEnabled', {'enabled': enabled});
  }

  Future<void> dispose() async {
    print("Disposing ARSceneController with id: $id");
    await _channel.invokeMethod('dispose', {'viewId': id});
    await _planesController.close();
    await _planeTapController.close();
    await _nodeTapController.close();
    await _trackingFailureController.close();
    await _augmentedImagesController.close();
  }
}
