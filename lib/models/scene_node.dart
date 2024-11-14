import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math_64.dart';
import '../utils/vector_converter.dart';
import 'pose.dart';

part 'scene_node.g.dart';
part 'scene_node.freezed.dart';

@freezed
class SceneNode with _$SceneNode {
  const factory SceneNode({
    required String id,
    @Vector3Converter() required Vector3 position,
    @QuaternionConverter() required Quaternion rotation,
    @Vector3Converter() required Vector3 scale,
    String? fileLocation,
  }) = _SceneNode;

  factory SceneNode.fromJson(Map<String, dynamic> json) =>
      _$SceneNodeFromJson(json);

  const SceneNode._();

  Pose get pose => Pose(translation: position, rotation: rotation);

  SceneNode copyWithPose(Pose newPose) {
    return copyWith(
      position: newPose.translation,
      rotation: newPose.rotation,
    );
  }

  SceneNode applyTransform(Matrix4 transform) {
    final newPose = pose.applyTransform(transform);
    return copyWithPose(newPose);
  }

  SceneNode translate(Vector3 translation) {
    final newPose = Pose(
      translation: pose.translation + translation,
      rotation: pose.rotation,
    );
    return copyWithPose(newPose);
  }

  SceneNode rotate(Quaternion rotation) {
    final newPose = Pose(
      translation: pose.translation,
      rotation: pose.rotation * rotation,
    );
    return copyWithPose(newPose);
  }

  SceneNode scaleBy(double factor) {
    return copyWith(scale: scale * factor);
  }
}
