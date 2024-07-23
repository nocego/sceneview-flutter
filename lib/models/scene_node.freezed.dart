// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scene_node.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SceneNode _$SceneNodeFromJson(Map<String, dynamic> json) {
  return _SceneNode.fromJson(json);
}

/// @nodoc
mixin _$SceneNode {
  String get id => throw _privateConstructorUsedError;
  @Vector3Converter()
  Vector3 get position => throw _privateConstructorUsedError;
  @QuaternionConverter()
  Quaternion get rotation => throw _privateConstructorUsedError;
  @Vector3Converter()
  Vector3 get scale => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SceneNodeCopyWith<SceneNode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SceneNodeCopyWith<$Res> {
  factory $SceneNodeCopyWith(SceneNode value, $Res Function(SceneNode) then) =
      _$SceneNodeCopyWithImpl<$Res, SceneNode>;
  @useResult
  $Res call(
      {String id,
      @Vector3Converter() Vector3 position,
      @QuaternionConverter() Quaternion rotation,
      @Vector3Converter() Vector3 scale});
}

/// @nodoc
class _$SceneNodeCopyWithImpl<$Res, $Val extends SceneNode>
    implements $SceneNodeCopyWith<$Res> {
  _$SceneNodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? rotation = null,
    Object? scale = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Vector3,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as Quaternion,
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as Vector3,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SceneNodeImplCopyWith<$Res>
    implements $SceneNodeCopyWith<$Res> {
  factory _$$SceneNodeImplCopyWith(
          _$SceneNodeImpl value, $Res Function(_$SceneNodeImpl) then) =
      __$$SceneNodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @Vector3Converter() Vector3 position,
      @QuaternionConverter() Quaternion rotation,
      @Vector3Converter() Vector3 scale});
}

/// @nodoc
class __$$SceneNodeImplCopyWithImpl<$Res>
    extends _$SceneNodeCopyWithImpl<$Res, _$SceneNodeImpl>
    implements _$$SceneNodeImplCopyWith<$Res> {
  __$$SceneNodeImplCopyWithImpl(
      _$SceneNodeImpl _value, $Res Function(_$SceneNodeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? position = null,
    Object? rotation = null,
    Object? scale = null,
  }) {
    return _then(_$SceneNodeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Vector3,
      rotation: null == rotation
          ? _value.rotation
          : rotation // ignore: cast_nullable_to_non_nullable
              as Quaternion,
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as Vector3,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SceneNodeImpl extends _SceneNode {
  const _$SceneNodeImpl(
      {required this.id,
      @Vector3Converter() required this.position,
      @QuaternionConverter() required this.rotation,
      @Vector3Converter() required this.scale})
      : super._();

  factory _$SceneNodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$SceneNodeImplFromJson(json);

  @override
  final String id;
  @override
  @Vector3Converter()
  final Vector3 position;
  @override
  @QuaternionConverter()
  final Quaternion rotation;
  @override
  @Vector3Converter()
  final Vector3 scale;

  @override
  String toString() {
    return 'SceneNode(id: $id, position: $position, rotation: $rotation, scale: $scale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SceneNodeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.rotation, rotation) ||
                other.rotation == rotation) &&
            (identical(other.scale, scale) || other.scale == scale));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, position, rotation, scale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SceneNodeImplCopyWith<_$SceneNodeImpl> get copyWith =>
      __$$SceneNodeImplCopyWithImpl<_$SceneNodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SceneNodeImplToJson(
      this,
    );
  }
}

abstract class _SceneNode extends SceneNode {
  const factory _SceneNode(
      {required final String id,
      @Vector3Converter() required final Vector3 position,
      @QuaternionConverter() required final Quaternion rotation,
      @Vector3Converter() required final Vector3 scale}) = _$SceneNodeImpl;
  const _SceneNode._() : super._();

  factory _SceneNode.fromJson(Map<String, dynamic> json) =
      _$SceneNodeImpl.fromJson;

  @override
  String get id;
  @override
  @Vector3Converter()
  Vector3 get position;
  @override
  @QuaternionConverter()
  Quaternion get rotation;
  @override
  @Vector3Converter()
  Vector3 get scale;
  @override
  @JsonKey(ignore: true)
  _$$SceneNodeImplCopyWith<_$SceneNodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
