// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pose.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Pose _$PoseFromJson(Map<String, dynamic> json) {
  return _Pose.fromJson(json);
}

/// @nodoc
mixin _$Pose {
  @Vector3Converter()
  Vector3 get translation => throw _privateConstructorUsedError;
  @QuaternionConverter()
  Quaternion get rotation => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PoseCopyWith<Pose> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoseCopyWith<$Res> {
  factory $PoseCopyWith(Pose value, $Res Function(Pose) then) =
      _$PoseCopyWithImpl<$Res, Pose>;
  @useResult
  $Res call(
      {@Vector3Converter() Vector3 translation,
      @QuaternionConverter() Quaternion rotation});
}

/// @nodoc
class _$PoseCopyWithImpl<$Res, $Val extends Pose>
    implements $PoseCopyWith<$Res> {
  _$PoseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? translation = null,
    Object? rotation = null,
  }) {
    return _then(_value.copyWith(
      translation: null == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as Vector3,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as Quaternion,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PoseImplCopyWith<$Res> implements $PoseCopyWith<$Res> {
  factory _$$PoseImplCopyWith(
          _$PoseImpl value, $Res Function(_$PoseImpl) then) =
      __$$PoseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@Vector3Converter() Vector3 translation,
      @QuaternionConverter() Quaternion rotation});
}

/// @nodoc
class __$$PoseImplCopyWithImpl<$Res>
    extends _$PoseCopyWithImpl<$Res, _$PoseImpl>
    implements _$$PoseImplCopyWith<$Res> {
  __$$PoseImplCopyWithImpl(_$PoseImpl _value, $Res Function(_$PoseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? translation = null,
    Object? rotation = null,
  }) {
    return _then(_$PoseImpl(
      translation: null == translation
          ? _value.translation
          : translation // ignore: cast_nullable_to_non_nullable
              as Vector3,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as Quaternion,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PoseImpl extends _Pose {
  const _$PoseImpl(
      {@Vector3Converter() required this.translation,
      @QuaternionConverter() required this.rotation})
      : super._();

  factory _$PoseImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoseImplFromJson(json);

  @override
  @Vector3Converter()
  final Vector3 translation;
  @override
  @QuaternionConverter()
  final Quaternion rotation;

  @override
  String toString() {
    return 'Pose(translation: $translation, rotation: $rotation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoseImpl &&
            (identical(other.translation, translation) ||
                other.translation == translation) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, translation, rotation);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PoseImplCopyWith<_$PoseImpl> get copyWith =>
      __$$PoseImplCopyWithImpl<_$PoseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoseImplToJson(
      this,
    );
  }
}

abstract class _Pose extends Pose {
  const factory _Pose(
      {@Vector3Converter() required final Vector3 translation,
      @QuaternionConverter() required final Quaternion rotation}) = _$PoseImpl;
  const _Pose._() : super._();

  factory _Pose.fromJson(Map<String, dynamic> json) = _$PoseImpl.fromJson;

  @override
  @Vector3Converter()
  Vector3 get translation;
  @override
  @QuaternionConverter()
  Quaternion get rotation;
  @override
  @JsonKey(ignore: true)
  _$$PoseImplCopyWith<_$PoseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
