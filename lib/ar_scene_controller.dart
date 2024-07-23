import 'dart:async';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart';
import 'models/scene_node.dart';
import 'models/plane.dart'
    as custom_plane; // Use 'as' to prefix the custom Plane class
import 'models/augmented_image.dart';
import 'enums/tracking_failure_reason.dart';
import 'utils/constants.dart';

class NodeTapEvent {
  final SceneNode node;
  final Vector3 position;

  NodeTapEvent(this.node, this.position);
}

class ARSceneController {
  final int id;
  final MethodChannel _channel;
  final EventChannel _eventChannel;

  final StreamController<List<custom_plane.Plane>> _planesController =
      StreamController<List<custom_plane.Plane>>.broadcast();
  final StreamController<NodeTapEvent> _nodeTapController =
      StreamController<NodeTapEvent>.broadcast();
  final StreamController<TrackingFailureReason> _trackingFailureController =
      StreamController<TrackingFailureReason>.broadcast();
  final StreamController<List<AugmentedImage>> _augmentedImagesController =
      StreamController<List<AugmentedImage>>.broadcast();

  Stream<List<custom_plane.Plane>> get planesStream => _planesController.stream;
  Stream<NodeTapEvent> get nodeTapStream => _nodeTapController.stream;
  Stream<TrackingFailureReason> get trackingFailureStream =>
      _trackingFailureController.stream;
  Stream<List<AugmentedImage>> get augmentedImagesStream =>
      _augmentedImagesController.stream;

  ARSceneController(this.id)
      : _channel = MethodChannel('${ARConstants.methodChannelName}_$id'),
        _eventChannel = EventChannel('${ARConstants.eventChannelName}_$id');

  Future<void> initialize() async {
    await _channel.invokeMethod('initialize');
    _eventChannel.receiveBroadcastStream().listen(_handleEvent);
  }

  void _handleEvent(dynamic event) {
    final Map<String, dynamic> map = Map<String, dynamic>.from(event);
    switch (map['type']) {
      case 'planesChanged':
        final List<custom_plane.Plane> planes = (map['planes'] as List)
            .map((e) => custom_plane.Plane.fromJson(e))
            .toList();
        _planesController.add(planes);
        break;
      case 'nodeTapped':
        final node = SceneNode.fromJson(map['node']);
        final position = vector3FromJson(map['position']);
        _nodeTapController.add(NodeTapEvent(node, position));
        break;
      case 'trackingFailureChanged':
        final reason = TrackingFailureReason.values[map['reason']];
        _trackingFailureController.add(reason);
        break;
      case 'augmentedImagesChanged':
        final List<AugmentedImage> images = (map['images'] as List)
            .map((e) => AugmentedImage.fromJson(e))
            .toList();
        _augmentedImagesController.add(images);
        break;
    }
  }

  Future<void> addNode(SceneNode node) async {
    await _channel.invokeMethod('addNode', node.toJson());
  }

  Future<void> removeNode(String nodeId) async {
    await _channel.invokeMethod('removeNode', {'nodeId': nodeId});
  }

  Future<void> updateNode(SceneNode node) async {
    await _channel.invokeMethod('updateNode', node.toJson());
  }

  Future<List<custom_plane.Plane>> getPlanes() async {
    final List result = await _channel.invokeMethod('getPlanes');
    return result.map((e) => custom_plane.Plane.fromJson(e)).toList();
  }

  Future<void> performHitTest(double x, double y) async {
    await _channel.invokeMethod('performHitTest', {'x': x, 'y': y});
  }

  Future<void> setPlaneDetectionEnabled(bool enabled) async {
    await _channel
        .invokeMethod('setPlaneDetectionEnabled', {'enabled': enabled});
  }

  Future<void> setLightEstimationEnabled(bool enabled) async {
    await _channel
        .invokeMethod('setLightEstimationEnabled', {'enabled': enabled});
  }

  Future<void> dispose() async {
    await _channel.invokeMethod('dispose');
    await _planesController.close();
    await _nodeTapController.close();
    await _trackingFailureController.close();
    await _augmentedImagesController.close();
  }
}

Vector3 vector3FromJson(List<dynamic> json) {
  return Vector3(
    (json[0] as num).toDouble(),
    (json[1] as num).toDouble(),
    (json[2] as num).toDouble(),
  );
}
