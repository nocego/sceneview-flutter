import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum TrackingFailureReason {
  @JsonValue('NONE')
  none,

  @JsonValue('BAD_STATE')
  badState,

  @JsonValue('INSUFFICIENT_LIGHT')
  insufficientLight,

  @JsonValue('EXCESSIVE_MOTION')
  excessiveMotion,

  @JsonValue('INSUFFICIENT_FEATURES')
  insufficientFeatures,

  @JsonValue('CAMERA_UNAVAILABLE')
  cameraUnavailable;

  static TrackingFailureReason fromJson(int json) =>
      TrackingFailureReason.values[json];
  int toJson() => index;
}

extension TrackingFailureReasonExtension on TrackingFailureReason {
  String get name {
    switch (this) {
      case TrackingFailureReason.none:
        return 'None';
      case TrackingFailureReason.badState:
        return 'Bad State';
      case TrackingFailureReason.insufficientLight:
        return 'Insufficient Light';
      case TrackingFailureReason.excessiveMotion:
        return 'Excessive Motion';
      case TrackingFailureReason.insufficientFeatures:
        return 'Insufficient Features';
      case TrackingFailureReason.cameraUnavailable:
        return 'Camera Unavailable';
    }
  }

  String get description {
    switch (this) {
      case TrackingFailureReason.none:
        return 'Tracking is working normally.';
      case TrackingFailureReason.badState:
        return 'The ARCore session has encountered an internal error.';
      case TrackingFailureReason.insufficientLight:
        return 'The camera feed is too dark. Try moving to a more well-lit area.';
      case TrackingFailureReason.excessiveMotion:
        return 'The device is moving too fast. Slow down your movement.';
      case TrackingFailureReason.insufficientFeatures:
        return 'ARCore cannot find enough visual features to track. Try moving to an area with more texture or detail.';
      case TrackingFailureReason.cameraUnavailable:
        return 'The camera is not available for ARCore to use. Another app might be using the camera.';
    }
  }

  bool get isTracking => this == TrackingFailureReason.none;
}
