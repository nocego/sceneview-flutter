// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'augmented_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AugmentedImage _$AugmentedImageFromJson(Map<String, dynamic> json) {
  return _AugmentedImage.fromJson(json);
}

/// @nodoc
mixin _$AugmentedImage {
  String get name => throw _privateConstructorUsedError;
  String get assetLocation => throw _privateConstructorUsedError;
  double get widthInMeters => throw _privateConstructorUsedError;
  bool get isTracking => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AugmentedImageCopyWith<AugmentedImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AugmentedImageCopyWith<$Res> {
  factory $AugmentedImageCopyWith(
          AugmentedImage value, $Res Function(AugmentedImage) then) =
      _$AugmentedImageCopyWithImpl<$Res, AugmentedImage>;
  @useResult
  $Res call(
      {String name,
      String assetLocation,
      double widthInMeters,
      bool isTracking});
}

/// @nodoc
class _$AugmentedImageCopyWithImpl<$Res, $Val extends AugmentedImage>
    implements $AugmentedImageCopyWith<$Res> {
  _$AugmentedImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? assetLocation = null,
    Object? widthInMeters = null,
    Object? isTracking = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      assetLocation: null == assetLocation
          ? _value.assetLocation
          : assetLocation // ignore: cast_nullable_to_non_nullable
              as String,
      widthInMeters: null == widthInMeters
          ? _value.widthInMeters
          : widthInMeters // ignore: cast_nullable_to_non_nullable
              as double,
      isTracking: null == isTracking
          ? _value.isTracking
          : isTracking // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AugmentedImageImplCopyWith<$Res>
    implements $AugmentedImageCopyWith<$Res> {
  factory _$$AugmentedImageImplCopyWith(_$AugmentedImageImpl value,
          $Res Function(_$AugmentedImageImpl) then) =
      __$$AugmentedImageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String assetLocation,
      double widthInMeters,
      bool isTracking});
}

/// @nodoc
class __$$AugmentedImageImplCopyWithImpl<$Res>
    extends _$AugmentedImageCopyWithImpl<$Res, _$AugmentedImageImpl>
    implements _$$AugmentedImageImplCopyWith<$Res> {
  __$$AugmentedImageImplCopyWithImpl(
      _$AugmentedImageImpl _value, $Res Function(_$AugmentedImageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? assetLocation = null,
    Object? widthInMeters = null,
    Object? isTracking = null,
  }) {
    return _then(_$AugmentedImageImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      assetLocation: null == assetLocation
          ? _value.assetLocation
          : assetLocation // ignore: cast_nullable_to_non_nullable
              as String,
      widthInMeters: null == widthInMeters
          ? _value.widthInMeters
          : widthInMeters // ignore: cast_nullable_to_non_nullable
              as double,
      isTracking: null == isTracking
          ? _value.isTracking
          : isTracking // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AugmentedImageImpl implements _AugmentedImage {
  const _$AugmentedImageImpl(
      {required this.name,
      required this.assetLocation,
      this.widthInMeters = 0.0,
      this.isTracking = false});

  factory _$AugmentedImageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AugmentedImageImplFromJson(json);

  @override
  final String name;
  @override
  final String assetLocation;
  @override
  @JsonKey()
  final double widthInMeters;
  @override
  @JsonKey()
  final bool isTracking;

  @override
  String toString() {
    return 'AugmentedImage(name: $name, assetLocation: $assetLocation, widthInMeters: $widthInMeters, isTracking: $isTracking)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AugmentedImageImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.assetLocation, assetLocation) ||
                other.assetLocation == assetLocation) &&
            (identical(other.widthInMeters, widthInMeters) ||
                other.widthInMeters == widthInMeters) &&
            (identical(other.isTracking, isTracking) ||
                other.isTracking == isTracking));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, assetLocation, widthInMeters, isTracking);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AugmentedImageImplCopyWith<_$AugmentedImageImpl> get copyWith =>
      __$$AugmentedImageImplCopyWithImpl<_$AugmentedImageImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AugmentedImageImplToJson(
      this,
    );
  }
}

abstract class _AugmentedImage implements AugmentedImage {
  const factory _AugmentedImage(
      {required final String name,
      required final String assetLocation,
      final double widthInMeters,
      final bool isTracking}) = _$AugmentedImageImpl;

  factory _AugmentedImage.fromJson(Map<String, dynamic> json) =
      _$AugmentedImageImpl.fromJson;

  @override
  String get name;
  @override
  String get assetLocation;
  @override
  double get widthInMeters;
  @override
  bool get isTracking;
  @override
  @JsonKey(ignore: true)
  _$$AugmentedImageImplCopyWith<_$AugmentedImageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
