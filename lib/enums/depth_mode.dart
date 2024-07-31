import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum DepthMode {
  @JsonValue('DISABLED')
  disabled,

  @JsonValue('AUTOMATIC')
  automatic,

  @JsonValue('RAW_DEPTH_ONLY')
  rawDepthOnly;

  const DepthMode();

  @override
  String toString() => name.toUpperCase();
}

extension DepthModeExtension on DepthMode {
  String get name {
    switch (this) {
      case DepthMode.disabled:
        return 'Disabled';
      case DepthMode.automatic:
        return 'Automatic';
      case DepthMode.rawDepthOnly:
        return 'Raw Depth Only';
    }
  }

  String get description {
    switch (this) {
      case DepthMode.disabled:
        return 'No depth information will be provided.';
      case DepthMode.automatic:
        return 'The best possible depth is estimated based on hardware and software sources.';
      case DepthMode.rawDepthOnly:
        return 'Provides a "raw", mostly unfiltered, depth image and depth confidence image.';
    }
  }
}
