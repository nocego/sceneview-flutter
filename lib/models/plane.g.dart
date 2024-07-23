// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plane.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaneImpl _$$PlaneImplFromJson(Map<String, dynamic> json) => _$PlaneImpl(
      id: json['id'] as String,
      type: $enumDecode(_$PlaneTypeEnumMap, json['type']),
      centerPose: Pose.fromJson(json['centerPose'] as Map<String, dynamic>),
      extentX: (json['extentX'] as num).toDouble(),
      extentZ: (json['extentZ'] as num).toDouble(),
      polygon: (json['polygon'] as List<dynamic>?)
              ?.map((e) => (e as List<dynamic>)
                  .map((e) => (e as num).toDouble())
                  .toList())
              .toList() ??
          const [],
      isTracking: json['isTracking'] as bool? ?? false,
      isSubsumed: json['isSubsumed'] as bool? ?? false,
    );

Map<String, dynamic> _$$PlaneImplToJson(_$PlaneImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'centerPose': instance.centerPose,
      'extentX': instance.extentX,
      'extentZ': instance.extentZ,
      'polygon': instance.polygon,
      'isTracking': instance.isTracking,
      'isSubsumed': instance.isSubsumed,
    };

const _$PlaneTypeEnumMap = {
  PlaneType.horizontalUpward: 'HORIZONTAL_UPWARD',
  PlaneType.horizontalDownward: 'HORIZONTAL_DOWNWARD',
  PlaneType.vertical: 'VERTICAL',
};
