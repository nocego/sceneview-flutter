// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plane.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Plane _$PlaneFromJson(Map<String, dynamic> json) {
  return _Plane.fromJson(json);
}

/// @nodoc
mixin _$Plane {
  String get id => throw _privateConstructorUsedError;
  PlaneType get type => throw _privateConstructorUsedError;
  Pose get centerPose => throw _privateConstructorUsedError;
  double get extentX => throw _privateConstructorUsedError;
  double get extentZ => throw _privateConstructorUsedError;
  List<List<double>> get polygon => throw _privateConstructorUsedError;
  bool get isTracking => throw _privateConstructorUsedError;
  bool get isSubsumed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaneCopyWith<Plane> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaneCopyWith<$Res> {
  factory $PlaneCopyWith(Plane value, $Res Function(Plane) then) =
      _$PlaneCopyWithImpl<$Res, Plane>;
  @useResult
  $Res call(
      {String id,
      PlaneType type,
      Pose centerPose,
      double extentX,
      double extentZ,
      List<List<double>> polygon,
      bool isTracking,
      bool isSubsumed});

  $PoseCopyWith<$Res> get centerPose;
}

/// @nodoc
class _$PlaneCopyWithImpl<$Res, $Val extends Plane>
    implements $PlaneCopyWith<$Res> {
  _$PlaneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? centerPose = null,
    Object? extentX = null,
    Object? extentZ = null,
    Object? polygon = null,
    Object? isTracking = null,
    Object? isSubsumed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlaneType,
      centerPose: null == centerPose
          ? _value.centerPose
          : centerPose // ignore: cast_nullable_to_non_nullable
              as Pose,
      extentX: null == extentX
          ? _value.extentX
          : extentX // ignore: cast_nullable_to_non_nullable
              as double,
      extentZ: null == extentZ
          ? _value.extentZ
          : extentZ // ignore: cast_nullable_to_non_nullable
              as double,
      polygon: null == polygon
          ? _value.polygon
          : polygon // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      isTracking: null == isTracking
          ? _value.isTracking
          : isTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubsumed: null == isSubsumed
          ? _value.isSubsumed
          : isSubsumed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PoseCopyWith<$Res> get centerPose {
    return $PoseCopyWith<$Res>(_value.centerPose, (value) {
      return _then(_value.copyWith(centerPose: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaneImplCopyWith<$Res> implements $PlaneCopyWith<$Res> {
  factory _$$PlaneImplCopyWith(
          _$PlaneImpl value, $Res Function(_$PlaneImpl) then) =
      __$$PlaneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      PlaneType type,
      Pose centerPose,
      double extentX,
      double extentZ,
      List<List<double>> polygon,
      bool isTracking,
      bool isSubsumed});

  @override
  $PoseCopyWith<$Res> get centerPose;
}

/// @nodoc
class __$$PlaneImplCopyWithImpl<$Res>
    extends _$PlaneCopyWithImpl<$Res, _$PlaneImpl>
    implements _$$PlaneImplCopyWith<$Res> {
  __$$PlaneImplCopyWithImpl(
      _$PlaneImpl _value, $Res Function(_$PlaneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? centerPose = null,
    Object? extentX = null,
    Object? extentZ = null,
    Object? polygon = null,
    Object? isTracking = null,
    Object? isSubsumed = null,
  }) {
    return _then(_$PlaneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlaneType,
      centerPose: null == centerPose
          ? _value.centerPose
          : centerPose // ignore: cast_nullable_to_non_nullable
              as Pose,
      extentX: null == extentX
          ? _value.extentX
          : extentX // ignore: cast_nullable_to_non_nullable
              as double,
      extentZ: null == extentZ
          ? _value.extentZ
          : extentZ // ignore: cast_nullable_to_non_nullable
              as double,
      polygon: null == polygon
          ? _value._polygon
          : polygon // ignore: cast_nullable_to_non_nullable
              as List<List<double>>,
      isTracking: null == isTracking
          ? _value.isTracking
          : isTracking // ignore: cast_nullable_to_non_nullable
              as bool,
      isSubsumed: null == isSubsumed
          ? _value.isSubsumed
          : isSubsumed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaneImpl implements _Plane {
  const _$PlaneImpl(
      {required this.id,
      required this.type,
      required this.centerPose,
      required this.extentX,
      required this.extentZ,
      final List<List<double>> polygon = const [],
      this.isTracking = false,
      this.isSubsumed = false})
      : _polygon = polygon;

  factory _$PlaneImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaneImplFromJson(json);

  @override
  final String id;
  @override
  final PlaneType type;
  @override
  final Pose centerPose;
  @override
  final double extentX;
  @override
  final double extentZ;
  final List<List<double>> _polygon;
  @override
  @JsonKey()
  List<List<double>> get polygon {
    if (_polygon is EqualUnmodifiableListView) return _polygon;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_polygon);
  }

  @override
  @JsonKey()
  final bool isTracking;
  @override
  @JsonKey()
  final bool isSubsumed;

  @override
  String toString() {
    return 'Plane(id: $id, type: $type, centerPose: $centerPose, extentX: $extentX, extentZ: $extentZ, polygon: $polygon, isTracking: $isTracking, isSubsumed: $isSubsumed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.centerPose, centerPose) ||
                other.centerPose == centerPose) &&
            (identical(other.extentX, extentX) || other.extentX == extentX) &&
            (identical(other.extentZ, extentZ) || other.extentZ == extentZ) &&
            const DeepCollectionEquality().equals(other._polygon, _polygon) &&
            (identical(other.isTracking, isTracking) ||
                other.isTracking == isTracking) &&
            (identical(other.isSubsumed, isSubsumed) ||
                other.isSubsumed == isSubsumed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      centerPose,
      extentX,
      extentZ,
      const DeepCollectionEquality().hash(_polygon),
      isTracking,
      isSubsumed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaneImplCopyWith<_$PlaneImpl> get copyWith =>
      __$$PlaneImplCopyWithImpl<_$PlaneImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaneImplToJson(
      this,
    );
  }
}

abstract class _Plane implements Plane {
  const factory _Plane(
      {required final String id,
      required final PlaneType type,
      required final Pose centerPose,
      required final double extentX,
      required final double extentZ,
      final List<List<double>> polygon,
      final bool isTracking,
      final bool isSubsumed}) = _$PlaneImpl;

  factory _Plane.fromJson(Map<String, dynamic> json) = _$PlaneImpl.fromJson;

  @override
  String get id;
  @override
  PlaneType get type;
  @override
  Pose get centerPose;
  @override
  double get extentX;
  @override
  double get extentZ;
  @override
  List<List<double>> get polygon;
  @override
  bool get isTracking;
  @override
  bool get isSubsumed;
  @override
  @JsonKey(ignore: true)
  _$$PlaneImplCopyWith<_$PlaneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
