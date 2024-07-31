// lib/models/plane.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/plane_type.dart';
import 'pose.dart';

part 'plane.freezed.dart';
part 'plane.g.dart';

@freezed
class Plane with _$Plane {
  const factory Plane({
    String? id,
    required PlaneType type,
    required Pose centerPose,
    @Default(1.0) double extentX,
    @Default(1.0) double extentZ,
  }) = _Plane;

  factory Plane.fromJson(Map<String, dynamic> json) => _$PlaneFromJson(json);
}
