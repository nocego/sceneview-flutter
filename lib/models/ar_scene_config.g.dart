// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_scene_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ARSceneConfigImpl _$$ARSceneConfigImplFromJson(Map<String, dynamic> json) =>
    _$ARSceneConfigImpl(
      planeFindingEnabled: json['planeFindingEnabled'] as bool? ?? true,
      planeRendererEnabled: json['planeRendererEnabled'] as bool? ?? true,
      depthEnabled: json['depthEnabled'] as bool? ?? true,
      instantPlacementEnabled: json['instantPlacementEnabled'] as bool? ?? true,
      augmentedImageDatabaseEnabled:
          json['augmentedImageDatabaseEnabled'] as bool? ?? true,
      augmentedFaceEnabled: json['augmentedFaceEnabled'] as bool? ?? true,
      lightEstimationMode: $enumDecodeNullable(
              _$LightEstimationModeEnumMap, json['lightEstimationMode']) ??
          LightEstimationMode.environmentalHDR,
      depthMode: $enumDecodeNullable(_$DepthModeEnumMap, json['depthMode']) ??
          DepthMode.automatic,
      instantPlacementMode: $enumDecodeNullable(
              _$InstantPlacementModeEnumMap, json['instantPlacementMode']) ??
          InstantPlacementMode.localYUp,
      cloudAnchorEnabled: json['cloudAnchorEnabled'] as bool? ?? false,
      geospatialEnabled: json['geospatialEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$$ARSceneConfigImplToJson(_$ARSceneConfigImpl instance) =>
    <String, dynamic>{
      'planeFindingEnabled': instance.planeFindingEnabled,
      'planeRendererEnabled': instance.planeRendererEnabled,
      'depthEnabled': instance.depthEnabled,
      'instantPlacementEnabled': instance.instantPlacementEnabled,
      'augmentedImageDatabaseEnabled': instance.augmentedImageDatabaseEnabled,
      'augmentedFaceEnabled': instance.augmentedFaceEnabled,
      'lightEstimationMode':
          _$LightEstimationModeEnumMap[instance.lightEstimationMode]!,
      'depthMode': _$DepthModeEnumMap[instance.depthMode]!,
      'instantPlacementMode':
          _$InstantPlacementModeEnumMap[instance.instantPlacementMode]!,
      'cloudAnchorEnabled': instance.cloudAnchorEnabled,
      'geospatialEnabled': instance.geospatialEnabled,
    };

const _$LightEstimationModeEnumMap = {
  LightEstimationMode.disabled: 'DISABLED',
  LightEstimationMode.ambientIntensity: 'AMBIENT_INTENSITY',
  LightEstimationMode.environmentalHDR: 'ENVIRONMENTAL_HDR',
};

const _$DepthModeEnumMap = {
  DepthMode.disabled: 'DISABLED',
  DepthMode.automatic: 'AUTOMATIC',
  DepthMode.rawDepthOnly: 'RAW_DEPTH_ONLY',
};

const _$InstantPlacementModeEnumMap = {
  InstantPlacementMode.disabled: 'DISABLED',
  InstantPlacementMode.localYUp: 'LOCAL_Y_UP',
};
