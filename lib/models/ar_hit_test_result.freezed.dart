// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ar_hit_test_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ARHitTestResult _$ARHitTestResultFromJson(Map<String, dynamic> json) {
  return _ARHitTestResult.fromJson(json);
}

/// @nodoc
mixin _$ARHitTestResult {
  @Vector3MapConverter()
  Vector3 get position => throw _privateConstructorUsedError;
  PlaneType get planeType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ARHitTestResultCopyWith<ARHitTestResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ARHitTestResultCopyWith<$Res> {
  factory $ARHitTestResultCopyWith(
          ARHitTestResult value, $Res Function(ARHitTestResult) then) =
      _$ARHitTestResultCopyWithImpl<$Res, ARHitTestResult>;
  @useResult
  $Res call({@Vector3MapConverter() Vector3 position, PlaneType planeType});
}

/// @nodoc
class _$ARHitTestResultCopyWithImpl<$Res, $Val extends ARHitTestResult>
    implements $ARHitTestResultCopyWith<$Res> {
  _$ARHitTestResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? planeType = null,
  }) {
    return _then(_value.copyWith(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Vector3,
      planeType: null == planeType
          ? _value.planeType
          : planeType // ignore: cast_nullable_to_non_nullable
              as PlaneType,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ARHitTestResultImplCopyWith<$Res>
    implements $ARHitTestResultCopyWith<$Res> {
  factory _$$ARHitTestResultImplCopyWith(_$ARHitTestResultImpl value,
          $Res Function(_$ARHitTestResultImpl) then) =
      __$$ARHitTestResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@Vector3MapConverter() Vector3 position, PlaneType planeType});
}

/// @nodoc
class __$$ARHitTestResultImplCopyWithImpl<$Res>
    extends _$ARHitTestResultCopyWithImpl<$Res, _$ARHitTestResultImpl>
    implements _$$ARHitTestResultImplCopyWith<$Res> {
  __$$ARHitTestResultImplCopyWithImpl(
      _$ARHitTestResultImpl _value, $Res Function(_$ARHitTestResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? position = null,
    Object? planeType = null,
  }) {
    return _then(_$ARHitTestResultImpl(
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Vector3,
      planeType: null == planeType
          ? _value.planeType
          : planeType // ignore: cast_nullable_to_non_nullable
              as PlaneType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ARHitTestResultImpl implements _ARHitTestResult {
  const _$ARHitTestResultImpl(
      {@Vector3MapConverter() required this.position, required this.planeType});

  factory _$ARHitTestResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ARHitTestResultImplFromJson(json);

  @override
  @Vector3MapConverter()
  final Vector3 position;
  @override
  final PlaneType planeType;

  @override
  String toString() {
    return 'ARHitTestResult(position: $position, planeType: $planeType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ARHitTestResultImpl &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.planeType, planeType) ||
                other.planeType == planeType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, position, planeType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ARHitTestResultImplCopyWith<_$ARHitTestResultImpl> get copyWith =>
      __$$ARHitTestResultImplCopyWithImpl<_$ARHitTestResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ARHitTestResultImplToJson(
      this,
    );
  }
}

abstract class _ARHitTestResult implements ARHitTestResult {
  const factory _ARHitTestResult(
      {@Vector3MapConverter() required final Vector3 position,
      required final PlaneType planeType}) = _$ARHitTestResultImpl;

  factory _ARHitTestResult.fromJson(Map<String, dynamic> json) =
      _$ARHitTestResultImpl.fromJson;

  @override
  @Vector3MapConverter()
  Vector3 get position;
  @override
  PlaneType get planeType;
  @override
  @JsonKey(ignore: true)
  _$$ARHitTestResultImplCopyWith<_$ARHitTestResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
