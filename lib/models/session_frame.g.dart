// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionFrameImpl _$$SessionFrameImplFromJson(Map<String, dynamic> json) =>
    _$SessionFrameImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      cameraPose: Pose.fromJson(json['cameraPose'] as Map<String, dynamic>),
      updatedPlanes: (json['updatedPlanes'] as List<dynamic>?)
              ?.map((e) => Plane.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      updatedAugmentedImages: (json['updatedAugmentedImages'] as List<dynamic>?)
              ?.map((e) => AugmentedImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lightEstimate: json['lightEstimate'] as Map<String, dynamic>? ?? const {},
      trackingFailureReason: json['trackingFailureReason'] as String?,
    );

Map<String, dynamic> _$$SessionFrameImplToJson(_$SessionFrameImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'cameraPose': instance.cameraPose,
      'updatedPlanes': instance.updatedPlanes,
      'updatedAugmentedImages': instance.updatedAugmentedImages,
      'lightEstimate': instance.lightEstimate,
      'trackingFailureReason': instance.trackingFailureReason,
    };

_$LightEstimateImpl _$$LightEstimateImplFromJson(Map<String, dynamic> json) =>
    _$LightEstimateImpl(
      pixelIntensity: (json['pixelIntensity'] as num).toDouble(),
      colorCorrection: (json['colorCorrection'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$LightEstimateImplToJson(_$LightEstimateImpl instance) =>
    <String, dynamic>{
      'pixelIntensity': instance.pixelIntensity,
      'colorCorrection': instance.colorCorrection,
    };
