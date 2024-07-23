import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sceneview_flutter/models/scene_node.dart';
import 'package:sceneview_flutter/models/session_frame.dart';
import 'package:sceneview_flutter/enums/tracking_failure_reason.dart';
import 'package:sceneview_flutter/utils/constants.dart';

import 'sceneview_flutter_platform_interface.dart';

class MethodChannelSceneviewFlutter extends SceneviewFlutterPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel(ARConstants.methodChannelName);

  final Map<int, MethodChannel> _channels = {};

  final StreamController<Object?> _eventStreamController =
      StreamController<Object?>.broadcast();

  MethodChannel _ensureChannelInitialized(int sceneId) {
    return _channels.putIfAbsent(sceneId, () {
      final channel = MethodChannel('scene_view_$sceneId');
      channel.setMethodCallHandler(
          (MethodCall call) => _handleMethodCall(call, sceneId));
      return channel;
    });
  }

  @override
  Future<void> init(int sceneId) async {
    final channel = _ensureChannelInitialized(sceneId);
    return channel.invokeMethod<void>('init');
  }

  @override
  void addNode(SceneNode node) {
    _channels.values.first.invokeMethod('addNode', node.toJson());
  }

  @override
  Stream<SessionFrame> onSessionUpdated() {
    return _eventStreamController.stream
        .where((event) => event is SessionFrame)
        .cast<SessionFrame>();
  }

  @override
  Stream<TrackingFailureReason> onTrackingFailureChanged() {
    return _eventStreamController.stream
        .where((event) => event is TrackingFailureReason)
        .cast<TrackingFailureReason>();
  }

  // New method for requesting camera permission
  @override
  Future<void> requestCameraPermission() async {
    try {
      await methodChannel.invokeMethod('requestCameraPermission');
    } on PlatformException catch (e) {
      print("Failed to request camera permission: '${e.message}'.");
      rethrow;
    }
  }

  // New stream for camera permission status
  final StreamController<bool> _cameraPermissionStreamController =
      StreamController<bool>.broadcast();

  @override
  Stream<bool> onCameraPermissionStatusChanged() {
    return _cameraPermissionStreamController.stream;
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int sceneId) async {
    switch (call.method) {
      case 'onTrackingFailureChanged':
        _eventStreamController
            .add(TrackingFailureReason.values[call.arguments as int]);
        break;
      case 'onSessionUpdated':
        try {
          final map = Map<String, dynamic>.from(call.arguments);
          if (map.containsKey('planes') &&
              (map['planes'] as List<dynamic>).isNotEmpty) {
            _eventStreamController.add(SessionFrame.fromJson(map));
          }
        } catch (ex, st) {
          print('Error in onSessionUpdated: $ex');
          print(st);
        }
        break;
      case 'onCameraPermissionGranted':
        _cameraPermissionStreamController.add(true);
        break;
      case 'onCameraPermissionDenied':
        _cameraPermissionStreamController.add(false);
        break;
      default:
        throw MissingPluginException();
    }
  }

  @override
  void dispose(int sceneId) {
    _channels.remove(sceneId);
    if (_channels.isEmpty) {
      _eventStreamController.close();
      _cameraPermissionStreamController.close();
    }
  }
}
