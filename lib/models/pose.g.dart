// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pose.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoseImpl _$$PoseImplFromJson(Map<String, dynamic> json) => _$PoseImpl(
      translation: const Vector3Converter()
          .fromJson(json['translation'] as List<double>),
      rotation: const QuaternionConverter()
          .fromJson(json['rotation'] as List<double>),
    );

Map<String, dynamic> _$$PoseImplToJson(_$PoseImpl instance) =>
    <String, dynamic>{
      'translation': const Vector3Converter().toJson(instance.translation),
      'rotation': const QuaternionConverter().toJson(instance.rotation),
    };
