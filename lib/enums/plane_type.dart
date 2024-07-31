// lib/enums/plane_type.dart

import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum PlaneType {
  @JsonValue('HORIZONTAL_UPWARD')
  horizontalUpward,

  @JsonValue('HORIZONTAL_DOWNWARD')
  horizontalDownward,

  @JsonValue('VERTICAL')
  vertical;

  static PlaneType fromJson(int json) => PlaneType.values[json];
  int toJson() => index;
}

extension PlaneTypeExtension on PlaneType {
  String get name {
    switch (this) {
      case PlaneType.horizontalUpward:
        return 'Horizontal Upward';
      case PlaneType.horizontalDownward:
        return 'Horizontal Downward';
      case PlaneType.vertical:
        return 'Vertical';
    }
  }

  String get description {
    switch (this) {
      case PlaneType.horizontalUpward:
        return 'A horizontal plane with normal facing upward (e.g., floor or tabletop).';
      case PlaneType.horizontalDownward:
        return 'A horizontal plane with normal facing downward (e.g., ceiling).';
      case PlaneType.vertical:
        return 'A vertical plane (e.g., wall).';
    }
  }

  bool get isHorizontal =>
      this == PlaneType.horizontalUpward ||
      this == PlaneType.horizontalDownward;
  bool get isVertical => this == PlaneType.vertical;
}
