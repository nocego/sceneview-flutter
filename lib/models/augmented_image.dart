import 'package:freezed_annotation/freezed_annotation.dart';

part 'augmented_image.freezed.dart';
part 'augmented_image.g.dart';

@freezed
class AugmentedImage with _$AugmentedImage {
  const factory AugmentedImage({
    required String name,
    required String assetName,
    @Default(0.0) double widthInMeters,
    @Default(false) bool isTracking,
  }) = _AugmentedImage;

  factory AugmentedImage.fromJson(Map<String, dynamic> json) =>
      _$AugmentedImageFromJson(json);
}
