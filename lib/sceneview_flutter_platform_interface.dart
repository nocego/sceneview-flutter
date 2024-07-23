import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sceneview_flutter/models/scene_node.dart';
import 'package:sceneview_flutter/models/session_frame.dart';
import 'package:sceneview_flutter/enums/tracking_failure_reason.dart';

import 'sceneview_flutter_method_channel.dart';

abstract class SceneviewFlutterPlatform extends PlatformInterface {
  SceneviewFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static SceneviewFlutterPlatform _instance = MethodChannelSceneviewFlutter();

  static SceneviewFlutterPlatform get instance => _instance;

  static set instance(SceneviewFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init(int sceneId) {
    throw UnimplementedError('init() has not been implemented.');
  }

  void addNode(SceneNode node) {
    throw UnimplementedError('addNode() has not been implemented.');
  }

  Stream<SessionFrame> onSessionUpdated() {
    throw UnimplementedError('onSessionUpdated() has not been implemented.');
  }

  Stream<TrackingFailureReason> onTrackingFailureChanged() {
    throw UnimplementedError(
        'onTrackingFailureChanged() has not been implemented.');
  }

  Future<void> requestCameraPermission() {
    throw UnimplementedError(
        'requestCameraPermission() has not been implemented.');
  }

  Stream<bool> onCameraPermissionStatusChanged() {
    throw UnimplementedError(
        'onCameraPermissionGranted() has not been implemented.');
  }

  void dispose(int sceneId) {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
