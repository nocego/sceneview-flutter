// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scene_node.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SceneNodeImpl _$$SceneNodeImplFromJson(Map<String, dynamic> json) =>
    _$SceneNodeImpl(
      id: json['id'] as String,
      position:
          const Vector3Converter().fromJson(json['position'] as List<double>),
      rotation: const QuaternionConverter()
          .fromJson(json['rotation'] as List<double>),
      scale: const Vector3Converter().fromJson(json['scale'] as List<double>),
      fileLocation: json['fileLocation'] as String?,
    );

Map<String, dynamic> _$$SceneNodeImplToJson(_$SceneNodeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'position': const Vector3Converter().toJson(instance.position),
      'rotation': const QuaternionConverter().toJson(instance.rotation),
      'scale': const Vector3Converter().toJson(instance.scale),
      'fileLocation': instance.fileLocation,
    };
