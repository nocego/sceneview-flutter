library sceneview_flutter;

export 'sceneview_flutter_platform_interface.dart';
export 'models/scene_node.dart';
export 'models/session_frame.dart';
export 'enums/tracking_failure_reason.dart';
export 'utils/constants.dart';

import 'models/scene_node.dart';
import 'models/session_frame.dart';
import 'enums/tracking_failure_reason.dart';
import 'sceneview_flutter_platform_interface.dart';

class SceneviewFlutter {
  final SceneviewFlutterPlatform _platform = SceneviewFlutterPlatform.instance;
  final int _sceneId;

  SceneviewFlutter(this._sceneId);

  Future<void> init() {
    return _platform.init(_sceneId);
  }

  void addNode(SceneNode node) {
    _platform.addNode(node);
  }

  Stream<SessionFrame> get onSessionUpdated => _platform.onSessionUpdated();

  Stream<TrackingFailureReason> get onTrackingFailureChanged =>
      _platform.onTrackingFailureChanged();

  Future<void> requestCameraPermission() {
    return _platform.requestCameraPermission();
  }

  Stream<bool> get onCameraPermissionStatusChanged =>
      _platform.onCameraPermissionStatusChanged();

  void dispose() {
    _platform.dispose(_sceneId);
  }
}
