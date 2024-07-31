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

  Future<void> init(int sceneId);

  void addNode(SceneNode node);

  Stream<SessionFrame> onSessionUpdated();

  Stream<TrackingFailureReason> onTrackingFailureChanged();

  Future<void> requestCameraPermission();

  Stream<bool> onCameraPermissionStatusChanged();

  Future<Map<String, dynamic>?> performHitTest(int sceneId, double x, double y);

  void dispose(int sceneId);
}
