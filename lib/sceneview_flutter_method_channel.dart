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
  final MethodChannel pluginChannel =
      const MethodChannel(ARConstants.methodChannelName);

  final Map<int, MethodChannel> _sceneChannels = {};
  final Map<int, bool> _initializedScenes = {};

  final StreamController<Object?> _eventStreamController =
      StreamController<Object?>.broadcast();
  final StreamController<bool> _cameraPermissionStreamController =
      StreamController<bool>.broadcast();

  MethodChannelSceneviewFlutter() {
    pluginChannel.setMethodCallHandler(_handlePluginMethodCall);
  }

  MethodChannel _getSceneChannel(int sceneId) {
    return _sceneChannels.putIfAbsent(sceneId, () {
      final channel =
          MethodChannel('${ARConstants.methodChannelName}_$sceneId');
      channel.setMethodCallHandler(
          (MethodCall call) => _handleSceneMethodCall(call, sceneId));
      return channel;
    });
  }

  @override
  Future<void> init(int sceneId) async {
    if (_initializedScenes[sceneId] == true) {
      print('AR view with id $sceneId is already initialized.');
      return;
    }

    final channel = _getSceneChannel(sceneId);
    try {
      await channel.invokeMethod<void>('initialize');
      _initializedScenes[sceneId] = true;
      print('AR view with id $sceneId initialized successfully.');
    } catch (e) {
      print('Error initializing AR view with id $sceneId: $e');
      rethrow;
    }
  }

  @override
  void addNode(SceneNode node) {
    final activeSceneId = _initializedScenes.keys.firstWhere(
      (id) => _initializedScenes[id] == true,
      orElse: () => -1,
    );

    if (activeSceneId != -1) {
      _getSceneChannel(activeSceneId).invokeMethod('addNode', node.toJson());
    } else {
      print('No initialized AR views. Cannot add node.');
    }
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

  // New method for plane tap events
  Stream<Map<String, dynamic>> onPlaneTap() {
    return _eventStreamController.stream
        .where((event) =>
            event is Map<String, dynamic> && event['event'] == 'onPlaneTap')
        .cast<Map<String, dynamic>>()
        .map((event) => event['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> requestCameraPermission() async {
    try {
      await pluginChannel.invokeMethod('requestCameraPermission');
    } on PlatformException catch (e) {
      print("Failed to request camera permission: '${e.message}'.");
      rethrow;
    }
  }

  @override
  Stream<bool> onCameraPermissionStatusChanged() {
    return _cameraPermissionStreamController.stream;
  }

  @override
  Future<Map<String, dynamic>?> performHitTest(
      int sceneId, double x, double y) async {
    final channel = _getSceneChannel(sceneId);
    return await channel.invokeMethod<Map<String, dynamic>>('performHitTest', {
      'x': x,
      'y': y,
    });
  }

  Future<dynamic> _handlePluginMethodCall(MethodCall call) async {
    switch (call.method) {
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

  Future<dynamic> _handleSceneMethodCall(MethodCall call, int sceneId) async {
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
      case 'onPlaneTap':
        // Handle plane tap event
        _eventStreamController.add(call.arguments);
        break;
      default:
        throw MissingPluginException();
    }
  }

  @override
  Future<void> dispose(int sceneId) async {
    try {
      await _getSceneChannel(sceneId).invokeMethod<void>('dispose');
    } catch (e) {
      print('Error disposing AR view with id $sceneId: $e');
    } finally {
      _sceneChannels.remove(sceneId);
      _initializedScenes.remove(sceneId);
      if (_sceneChannels.isEmpty) {
        _eventStreamController.close();
        _cameraPermissionStreamController.close();
      }
    }
  }
}
