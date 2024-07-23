import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum InstantPlacementMode {
  @JsonValue('DISABLED')
  disabled,

  @JsonValue('LOCAL_Y_UP')
  localYUp;

  const InstantPlacementMode();

  @override
  String toString() => name.toUpperCase();
}

extension InstantPlacementModeExtension on InstantPlacementMode {
  String get name {
    switch (this) {
      case InstantPlacementMode.disabled:
        return 'Disabled';
      case InstantPlacementMode.localYUp:
        return 'Local Y-Up';
    }
  }

  String get description {
    switch (this) {
      case InstantPlacementMode.disabled:
        return 'Instant Placement is disabled. Hit tests will not return instant placement points.';
      case InstantPlacementMode.localYUp:
        return 'Instant Placement is enabled. Hit tests may return instant placement points with Y-up orientation.';
    }
  }
}
