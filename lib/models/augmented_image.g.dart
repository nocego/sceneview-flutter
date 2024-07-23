// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'augmented_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AugmentedImageImpl _$$AugmentedImageImplFromJson(Map<String, dynamic> json) =>
    _$AugmentedImageImpl(
      name: json['name'] as String,
      assetName: json['assetName'] as String,
      widthInMeters: (json['widthInMeters'] as num?)?.toDouble() ?? 0.0,
      isTracking: json['isTracking'] as bool? ?? false,
    );

Map<String, dynamic> _$$AugmentedImageImplToJson(
        _$AugmentedImageImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'assetName': instance.assetName,
      'widthInMeters': instance.widthInMeters,
      'isTracking': instance.isTracking,
    };
