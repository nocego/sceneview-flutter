// lib/models/pose.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math_64.dart';
import '../utils/vector_converter.dart';
import 'dart:math' as math;
part 'pose.freezed.dart';
part 'pose.g.dart';

@freezed
class Pose with _$Pose {
  const factory Pose({
    @Vector3Converter() required Vector3 translation,
    @QuaternionConverter() required Quaternion rotation,
  }) = _Pose;

  factory Pose.fromJson(Map<String, dynamic> json) => _$PoseFromJson(json);

  const Pose._();

  Matrix4 get matrix =>
      Matrix4.compose(translation, rotation, Vector3.all(1.0));

  Pose applyTransform(Matrix4 transform) {
    final newMatrix = transform * matrix;
    final newTranslation = Vector3.zero();
    final newRotation = Quaternion.identity();
    final newScale = Vector3.zero();
    newMatrix.decompose(newTranslation, newRotation, newScale);
    return Pose(translation: newTranslation, rotation: newRotation);
  }

  Pose interpolate(Pose other, double t) {
    return Pose(
      translation: _lerpVector3(translation, other.translation, t),
      rotation: _slerpQuaternion(rotation, other.rotation, t),
    );
  }

  // Helper method for Vector3 linear interpolation
  static Vector3 _lerpVector3(Vector3 a, Vector3 b, double t) {
    return Vector3(
      _lerpDouble(a.x, b.x, t),
      _lerpDouble(a.y, b.y, t),
      _lerpDouble(a.z, b.z, t),
    );
  }

  // Helper method for double linear interpolation
  static double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }

  // Helper method for Quaternion spherical linear interpolation (slerp)
  static Quaternion _slerpQuaternion(Quaternion a, Quaternion b, double t) {
    double dot = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;

    if (dot < 0.0) {
      b = Quaternion(-b.x, -b.y, -b.z, -b.w);
      dot = -dot;
    }

    if (dot > 0.9995) {
      return Quaternion(
        _lerpDouble(a.x, b.x, t),
        _lerpDouble(a.y, b.y, t),
        _lerpDouble(a.z, b.z, t),
        _lerpDouble(a.w, b.w, t),
      )..normalize();
    }

    double theta0 = math.acos(dot);
    double theta = theta0 * t;

    double sinTheta = math.sin(theta);
    double sinTheta0 = math.sin(theta0);

    double s0 = math.cos(theta) - dot * sinTheta / sinTheta0;
    double s1 = sinTheta / sinTheta0;

    return Quaternion(
      a.x * s0 + b.x * s1,
      a.y * s0 + b.y * s1,
      a.z * s0 + b.z * s1,
      a.w * s0 + b.w * s1,
    );
  }
}
