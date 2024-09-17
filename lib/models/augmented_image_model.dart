// lib/models/augmented_image_model.dart

import 'dart:convert';

class AugmentedImageModel {
  final String path;
  final double? scaleX;
  final double? scaleY;
  final double? scaleZ;

  AugmentedImageModel({
    required this.path,
    this.scaleX,
    this.scaleY,
    this.scaleZ,
  });

  String toJson() {
    final Map<String, dynamic> data = {
      'path': path,
      'scaleX': scaleX,
      'scaleY': scaleY,
      'scaleZ': scaleZ,
    };
    return jsonEncode(data);
  }
}
