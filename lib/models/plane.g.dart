// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaneImpl _$$PlaneImplFromJson(Map<String, dynamic> json) => _$PlaneImpl(
      id: json['id'] as String?,
      type: $enumDecode(_$PlaneTypeEnumMap, json['type']),
      centerPose: Pose.fromJson(json['centerPose'] as Map<String, dynamic>),
      extentX: (json['extentX'] as num?)?.toDouble() ?? 1.0,
      extentZ: (json['extentZ'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$PlaneImplToJson(_$PlaneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'centerPose': instance.centerPose,
      'extentX': instance.extentX,
      'extentZ': instance.extentZ,
    };

const _$PlaneTypeEnumMap = {
  PlaneType.horizontalUpward: 'HORIZONTAL_UPWARD',
  PlaneType.horizontalDownward: 'HORIZONTAL_DOWNWARD',
  PlaneType.vertical: 'VERTICAL',
};
