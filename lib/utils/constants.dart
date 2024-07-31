// lib/utils/constants.dart

import 'dart:ui';

import 'package:vector_math/vector_math_64.dart';

class ARConstants {
  // AR Session configuration constants
  static const double defaultFocusSquareSize = 0.17;
  static const double defaultHitTestInstantPlacementDistance = 2.0;
  static const double defaultPlaneDiscoveryDistance = 5.0;

  // AR Plane visualization constants
  static const Color defaultPlaneColor = Color.fromARGB(127, 0, 200, 255);
  static const double defaultPlaneOpacity = 0.5;
  static const double defaultPlaneLineWidth = 0.005;

  // AR Node constants
  static const double defaultNodeScale = 1.0;
  static Vector3 defaultNodePosition = Vector3(0, 0, -1);
  static Quaternion defaultNodeRotation = Quaternion.identity();

  // AR Light estimation constants
  static const double defaultAmbientIntensity = 1000.0;
  static const Color defaultAmbientColor = Color.fromARGB(255, 255, 255, 255);

  // AR Anchor constants
  static const int maxAnchors = 20;

  // AR Image tracking constants
  static const double defaultImageTrackingMaxImages = 4;
  static const double defaultImageTrackingMaxSize = 0.25;

  // AR Face tracking constants
  static const int maxFaces = 1;

  // AR Depth constants
  static const double defaultDepthNear = 0.1;
  static const double defaultDepthFar = 20.0;

  // AR Hit test constants
  static const double defaultHitTestDistance = 2.0;
  static const double defaultHitTestAreaSize = 0.1;

  // AR UI constants
  static const double defaultUIScale = 1.0;
  static const double defaultUIDistance = 2.0;

  // Method channel names
  static const String methodChannelName = 'sceneview_flutter';
  static const String eventChannelName = 'sceneview_flutter/events';

  // Method names
  static const String initializeARMethod = 'initializeAR';
  static const String addNodeMethod = 'addNode';
  static const String removeNodeMethod = 'removeNode';
  static const String updateNodeMethod = 'updateNode';
  static const String performHitTestMethod = 'performHitTest';
  static const String setPlaneDetectionMethod = 'setPlaneDetection';
  static const String setLightEstimationMethod = 'setLightEstimation';
  static const String setFocusSquareMethod = 'setFocusSquare';

  // Event names
  static const String onPlaneDetectedEvent = 'onPlaneDetected';
  static const String onNodeTappedEvent = 'onNodeTapped';
  static const String onTrackingStateChangedEvent = 'onTrackingStateChanged';

  // Asset paths
  static const String defaultModelPath = 'assets/models/default_model.glb';
  static const String defaultTexturePath =
      'assets/textures/default_texture.png';

  // Permissions
  static const String cameraPermission = 'android.permission.CAMERA';
}
