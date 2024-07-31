import 'plane.dart';
import 'package:vector_math/vector_math_64.dart' as vector_math;

class PlaneTapEvent {
  final Plane plane;
  final vector_math.Vector3 position;
  PlaneTapEvent(this.plane, this.position);
}
