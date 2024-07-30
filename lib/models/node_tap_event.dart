import 'package:vector_math/vector_math_64.dart' as vector_math;
import 'scene_node.dart';

class NodeTapEvent {
  final SceneNode node;
  final vector_math.Vector3 position;

  NodeTapEvent(this.node, this.position);
}
