import 'package:vector_math/vector_math_64.dart' as vector_math;
import '../models/plane.dart';
import '../models/plane_tap_event.dart';
import '../models/node_tap_event.dart';
import '../models/scene_node.dart';
import '../models/pose.dart';
import '../models/augmented_image.dart';
import '../enums/plane_type.dart';
import '../enums/tracking_failure_reason.dart';
import '../utils/channel_manager.dart';
import '../utils/vector_converter.dart';
import 'ar_scene_controller.dart';

class EventHandler {
  final ChannelManager _channelManager;
  final ARSceneController _controller;

  EventHandler(this._channelManager, this._controller);

  void setupEventChannel() {
    print("Setting up event channel listener");
    _channelManager.eventStream.listen(
      (dynamic event) {
        print("Received event: $event");
        if (event is Map) {
          String eventName = event['event'] as String;
          dynamic data = event['data'];
          handleEvent(eventName, data);
        } else {
          print("Unexpected event format: ${event.runtimeType}");
        }
      },
      onError: (dynamic error) {
        print("Error from event channel: $error");
      },
    );
  }

  void handleEvent(String eventName, dynamic data) {
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
      case 'onAugmentedImageTracked':
        if (data is Map) {
          _handleAugmentedImageTracked(data);
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
      _controller.planesController.add([]);
      return;
    }

    final List<Plane> planes = planesList.asMap().entries.map((entry) {
      final index = entry.key;
      final e = entry.value;

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

      return plane.copyWith(
          id: 'plane_${DateTime.now().millisecondsSinceEpoch}_${index}_${plane.type}');
    }).toList();

    _controller.planesController.add(planes);
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
      _controller.planeTapController.add(PlaneTapEvent(plane, position));
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

    _controller.nodeTapController.add(NodeTapEvent(node, position));
    print("NodeTapEvent added to controller");
  }

  void _handleAugmentedImageTracked(Map data) {
    final imageName = data['imageName'] as String;
    final isTracking = data['isTracking'] as bool;

    final updatedImage = AugmentedImage(
      name: imageName,
      assetLocation: '',
      isTracking: isTracking,
    );

    _controller.augmentedImagesController.add([updatedImage]);
  }

  void _handleTrackingFailureChanged(int data) {
    final reason = TrackingFailureReason.values[data];
    print("Tracking failure changed: $reason");
    _controller.trackingFailureController.add(reason);
  }

  void _handleAugmentedImagesChanged(Map data) {
    final List<AugmentedImage> images = (data['images'] as List)
        .map((e) => AugmentedImage.fromJson(e))
        .toList();
    print("Augmented images changed: ${images.length} images");
    _controller.augmentedImagesController.add(images);
  }
}
