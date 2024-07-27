//example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:sceneview_flutter/ar_scene_controller.dart';
import 'package:sceneview_flutter/ar_scene_view.dart';
import 'package:sceneview_flutter/sceneview_flutter.dart';
import 'package:sceneview_flutter/models/ar_scene_config.dart';
import 'package:sceneview_flutter/enums/light_estimation_mode.dart';
import 'package:sceneview_flutter/enums/instant_placement_mode.dart';
import 'package:sceneview_flutter/enums/depth_mode.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Scene Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Scene Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ARScreen()),
            );
          },
          child: const Text('Open AR View'),
        ),
      ),
    );
  }
}

class ARScreen extends StatefulWidget {
  const ARScreen({super.key});

  @override
  State<ARScreen> createState() => _ARScreenState();
}

class _ARScreenState extends State<ARScreen> {
  TrackingFailureReason? reason;
  late ARSceneController arSceneController;

  void _addModelAtPosition(vector_math.Vector3 position) {
    arSceneController.addNode(
      SceneNode(
        id: 'model_${DateTime.now().millisecondsSinceEpoch}',
        position: position,
        rotation: vector_math.Quaternion.identity(),
        scale: vector_math.Vector3(0.5, 0.5, 0.5),
        fileLocation: 'assets/models/MaterialSuite.glb',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('Building ARSceneView');
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR View'),
      ),
      body: ARSceneView(
        config: const ARSceneConfig(
          lightEstimationMode: LightEstimationMode.ambientIntensity,
          instantPlacementMode: InstantPlacementMode.disabled,
          depthMode: DepthMode.automatic,
        ),
        onViewCreated: (controller) {
          try {
            print('flutter: onViewCreated');
            arSceneController = controller;
          } catch (e) {
            print('Error in onViewCreated: $e');
          }
        },
        onPlaneTapped: (plane, position) {
          print('Plane tapped: ${plane.type} at $position');
          _addModelAtPosition(position);
        },
        onNodeTapped: (node, position) {
          print('Node tapped: ${node.id} at $position');
        },
      ),
    );
  }

  @override
  void dispose() {
    arSceneController.dispose();
    super.dispose();
  }
}
