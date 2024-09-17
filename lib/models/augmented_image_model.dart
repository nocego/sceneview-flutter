// lib/models/augmented_image_model.dart

import 'dart:convert';

class AugmentedImageModel {
  final String path;
  final double? scaleX;
  final double? scaleY;
  final double? scaleZ;
  final double positionXRelative;
  final double positionYRelative;
  final double positionZRelative;

  AugmentedImageModel({
    required this.path,
    this.scaleX,
    this.scaleY,
    this.scaleZ,
    this.positionXRelative = 0.0,
    this.positionYRelative = 0.0,
    this.positionZRelative = 0.0,
  });

  String toJson() {
    final Map<String, dynamic> data = {
      'path': path,
      'scaleX': scaleX,
      'scaleY': scaleY,
      'scaleZ': scaleZ,
      'positionXRelative': positionXRelative,
      'positionYRelative': positionYRelative,
      'positionZRelative': positionZRelative,
    };
    return jsonEncode(data);
  }
}
