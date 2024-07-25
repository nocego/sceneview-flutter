// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ar_hit_test_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ARHitTestResultImpl _$$ARHitTestResultImplFromJson(
        Map<String, dynamic> json) =>
    _$ARHitTestResultImpl(
      position: const Vector3MapConverter()
          .fromJson(json['position'] as Map<String, dynamic>),
      planeType: $enumDecode(_$PlaneTypeEnumMap, json['planeType']),
    );

Map<String, dynamic> _$$ARHitTestResultImplToJson(
        _$ARHitTestResultImpl instance) =>
    <String, dynamic>{
      'position': const Vector3MapConverter().toJson(instance.position),
      'planeType': instance.planeType,
    };

const _$PlaneTypeEnumMap = {
  PlaneType.horizontalUpward: 'HORIZONTAL_UPWARD',
  PlaneType.horizontalDownward: 'HORIZONTAL_DOWNWARD',
  PlaneType.vertical: 'VERTICAL',
};
