import 'package:freezed_annotation/freezed_annotation.dart';
import 'plane.dart';
import 'augmented_image.dart';
import 'pose.dart';

part 'session_frame.freezed.dart';
part 'session_frame.g.dart';

@freezed
class SessionFrame with _$SessionFrame {
  const factory SessionFrame({
    required DateTime timestamp,
    required Pose cameraPose,
    @Default([]) List<Plane> updatedPlanes,
    @Default([]) List<AugmentedImage> updatedAugmentedImages,
    @Default({}) Map<String, dynamic> lightEstimate,
    String? trackingFailureReason,
  }) = _SessionFrame;

  factory SessionFrame.fromJson(Map<String, dynamic> json) =>
      _$SessionFrameFromJson(json);

  const SessionFrame._();

  bool get isTracking => trackingFailureReason == null;

  List<Plane> get trackingPlanes =>
      updatedPlanes.where((plane) => plane.isTracking).toList();

  List<AugmentedImage> get trackingAugmentedImages =>
      updatedAugmentedImages.where((image) => image.isTracking).toList();
}

@freezed
class LightEstimate with _$LightEstimate {
  const factory LightEstimate({
    required double pixelIntensity,
    required List<double> colorCorrection,
  }) = _LightEstimate;

  factory LightEstimate.fromJson(Map<String, dynamic> json) =>
      _$LightEstimateFromJson(json);
}
