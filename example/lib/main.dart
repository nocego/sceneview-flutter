import 'package:flutter/material.dart';
import 'package:sceneview_flutter/ar_scene_controller.dart';
import 'package:sceneview_flutter/ar_scene_view.dart';
import 'package:sceneview_flutter/sceneview_flutter.dart';
import 'package:sceneview_flutter/models/ar_scene_config.dart';
import 'package:sceneview_flutter/models/augmented_image.dart';
import 'package:sceneview_flutter/enums/light_estimation_mode.dart';
import 'package:sceneview_flutter/enums/instant_placement_mode.dart';
import 'package:sceneview_flutter/enums/depth_mode.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TrackingFailureReason? reason;
  bool posed = false;
  late ARSceneController arSceneController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Scene view example app'),
        ),
        body: Stack(
          children: [
            ARSceneView(
              config: const ARSceneConfig(
                lightEstimationMode: LightEstimationMode.ambientIntensity,
                instantPlacementMode: InstantPlacementMode.disabled,
                depthMode: DepthMode.automatic,
              ),
              augmentedImages: const [
                AugmentedImage(
                  name: 'rabbit',
                  assetName: 'assets/augmentedimages/rabbit.jpg',
                ),
              ],
              onViewCreated: (controller) {
                print('flutter: onViewCreated');
                arSceneController = controller;
              },
              onPlanesChanged: (planes) {
                print('onPlanesChanged: ${planes.length} planes');
                if (!posed && planes.isNotEmpty) {
                  final firstPlane = planes.first;
                  arSceneController.addNode(
                    SceneNode(
                      id: 'model',
                      position: firstPlane.centerPose.translation,
                      rotation: firstPlane.centerPose.rotation,
                      scale: vector_math.Vector3(1, 1, 1),
                    ),
                  );
                  posed = true;
                }
              },
              onTrackingFailureChanged: (failureReason) {
                print('onTrackingFailureChanged: $failureReason');
                if (reason != failureReason) {
                  setState(() {
                    reason = failureReason;
                  });
                }
              },
            ),
            if (reason != null && reason != TrackingFailureReason.none)
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  reason!.name,
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
