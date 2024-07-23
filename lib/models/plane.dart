import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/plane_type.dart';
import 'pose.dart';

part 'plane.freezed.dart';
part 'plane.g.dart';

@freezed
class Plane with _$Plane {
  const factory Plane({
    required String id,
    required PlaneType type,
    required Pose centerPose,
    required double extentX,
    required double extentZ,
    @Default([]) List<List<double>> polygon,
    @Default(false) bool isTracking,
    @Default(false) bool isSubsumed,
  }) = _Plane;

  factory Plane.fromJson(Map<String, dynamic> json) => _$PlaneFromJson(json);
}
