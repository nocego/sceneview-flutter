// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SessionFrameImpl _$$SessionFrameImplFromJson(Map<String, dynamic> json) =>
    _$SessionFrameImpl(
      planes: (json['planes'] as List<dynamic>)
          .map((e) => Plane.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SessionFrameImplToJson(_$SessionFrameImpl instance) =>
    <String, dynamic>{
      'planes': instance.planes,
    };
