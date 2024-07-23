import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum LightEstimationMode {
  @JsonValue('DISABLED')
  disabled,

  @JsonValue('AMBIENT_INTENSITY')
  ambientIntensity,

  @JsonValue('ENVIRONMENTAL_HDR')
  environmentalHDR;

  const LightEstimationMode();

  @override
  String toString() => name.toUpperCase();
}

extension LightEstimationModeExtension on LightEstimationMode {
  String get name {
    switch (this) {
      case LightEstimationMode.disabled:
        return 'Disabled';
      case LightEstimationMode.ambientIntensity:
        return 'Ambient Intensity';
      case LightEstimationMode.environmentalHDR:
        return 'Environmental HDR';
    }
  }

  String get description {
    switch (this) {
      case LightEstimationMode.disabled:
        return 'Light estimation is disabled.';
      case LightEstimationMode.ambientIntensity:
        return 'Light estimation provides a single-value ambient intensity estimate and three (R, G, B) color correction values.';
      case LightEstimationMode.environmentalHDR:
        return 'Light estimation provides inferred Environmental HDR lighting estimation in linear color space.';
    }
  }

  bool get isEnabled => this != LightEstimationMode.disabled;
}
