// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_frame.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SessionFrame _$SessionFrameFromJson(Map<String, dynamic> json) {
  return _SessionFrame.fromJson(json);
}

/// @nodoc
mixin _$SessionFrame {
  DateTime get timestamp => throw _privateConstructorUsedError;
  Pose get cameraPose => throw _privateConstructorUsedError;
  List<Plane> get updatedPlanes => throw _privateConstructorUsedError;
  List<AugmentedImage> get updatedAugmentedImages =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> get lightEstimate => throw _privateConstructorUsedError;
  String? get trackingFailureReason => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SessionFrameCopyWith<SessionFrame> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionFrameCopyWith<$Res> {
  factory $SessionFrameCopyWith(
          SessionFrame value, $Res Function(SessionFrame) then) =
      _$SessionFrameCopyWithImpl<$Res, SessionFrame>;
  @useResult
  $Res call(
      {DateTime timestamp,
      Pose cameraPose,
      List<Plane> updatedPlanes,
      List<AugmentedImage> updatedAugmentedImages,
      Map<String, dynamic> lightEstimate,
      String? trackingFailureReason});

  $PoseCopyWith<$Res> get cameraPose;
}

/// @nodoc
class _$SessionFrameCopyWithImpl<$Res, $Val extends SessionFrame>
    implements $SessionFrameCopyWith<$Res> {
  _$SessionFrameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? cameraPose = null,
    Object? updatedPlanes = null,
    Object? updatedAugmentedImages = null,
    Object? lightEstimate = null,
    Object? trackingFailureReason = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cameraPose: null == cameraPose
          ? _value.cameraPose
          : cameraPose // ignore: cast_nullable_to_non_nullable
              as Pose,
      updatedPlanes: null == updatedPlanes
          ? _value.updatedPlanes
          : updatedPlanes // ignore: cast_nullable_to_non_nullable
              as List<Plane>,
      updatedAugmentedImages: null == updatedAugmentedImages
          ? _value.updatedAugmentedImages
          : updatedAugmentedImages // ignore: cast_nullable_to_non_nullable
              as List<AugmentedImage>,
      lightEstimate: null == lightEstimate
          ? _value.lightEstimate
          : lightEstimate // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      trackingFailureReason: freezed == trackingFailureReason
          ? _value.trackingFailureReason
          : trackingFailureReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PoseCopyWith<$Res> get cameraPose {
    return $PoseCopyWith<$Res>(_value.cameraPose, (value) {
      return _then(_value.copyWith(cameraPose: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SessionFrameImplCopyWith<$Res>
    implements $SessionFrameCopyWith<$Res> {
  factory _$$SessionFrameImplCopyWith(
          _$SessionFrameImpl value, $Res Function(_$SessionFrameImpl) then) =
      __$$SessionFrameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      Pose cameraPose,
      List<Plane> updatedPlanes,
      List<AugmentedImage> updatedAugmentedImages,
      Map<String, dynamic> lightEstimate,
      String? trackingFailureReason});

  @override
  $PoseCopyWith<$Res> get cameraPose;
}

/// @nodoc
class __$$SessionFrameImplCopyWithImpl<$Res>
    extends _$SessionFrameCopyWithImpl<$Res, _$SessionFrameImpl>
    implements _$$SessionFrameImplCopyWith<$Res> {
  __$$SessionFrameImplCopyWithImpl(
      _$SessionFrameImpl _value, $Res Function(_$SessionFrameImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? cameraPose = null,
    Object? updatedPlanes = null,
    Object? updatedAugmentedImages = null,
    Object? lightEstimate = null,
    Object? trackingFailureReason = freezed,
  }) {
    return _then(_$SessionFrameImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      cameraPose: null == cameraPose
          ? _value.cameraPose
          : cameraPose // ignore: cast_nullable_to_non_nullable
              as Pose,
      updatedPlanes: null == updatedPlanes
          ? _value._updatedPlanes
          : updatedPlanes // ignore: cast_nullable_to_non_nullable
              as List<Plane>,
      updatedAugmentedImages: null == updatedAugmentedImages
          ? _value._updatedAugmentedImages
          : updatedAugmentedImages // ignore: cast_nullable_to_non_nullable
              as List<AugmentedImage>,
      lightEstimate: null == lightEstimate
          ? _value._lightEstimate
          : lightEstimate // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      trackingFailureReason: freezed == trackingFailureReason
          ? _value.trackingFailureReason
          : trackingFailureReason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionFrameImpl extends _SessionFrame {
  const _$SessionFrameImpl(
      {required this.timestamp,
      required this.cameraPose,
      final List<Plane> updatedPlanes = const [],
      final List<AugmentedImage> updatedAugmentedImages = const [],
      final Map<String, dynamic> lightEstimate = const {},
      this.trackingFailureReason})
      : _updatedPlanes = updatedPlanes,
        _updatedAugmentedImages = updatedAugmentedImages,
        _lightEstimate = lightEstimate,
        super._();

  factory _$SessionFrameImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionFrameImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  final Pose cameraPose;
  final List<Plane> _updatedPlanes;
  @override
  @JsonKey()
  List<Plane> get updatedPlanes {
    if (_updatedPlanes is EqualUnmodifiableListView) return _updatedPlanes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_updatedPlanes);
  }

  final List<AugmentedImage> _updatedAugmentedImages;
  @override
  @JsonKey()
  List<AugmentedImage> get updatedAugmentedImages {
    if (_updatedAugmentedImages is EqualUnmodifiableListView)
      return _updatedAugmentedImages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_updatedAugmentedImages);
  }

  final Map<String, dynamic> _lightEstimate;
  @override
  @JsonKey()
  Map<String, dynamic> get lightEstimate {
    if (_lightEstimate is EqualUnmodifiableMapView) return _lightEstimate;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_lightEstimate);
  }

  @override
  final String? trackingFailureReason;

  @override
  String toString() {
    return 'SessionFrame(timestamp: $timestamp, cameraPose: $cameraPose, updatedPlanes: $updatedPlanes, updatedAugmentedImages: $updatedAugmentedImages, lightEstimate: $lightEstimate, trackingFailureReason: $trackingFailureReason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionFrameImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.cameraPose, cameraPose) ||
                other.cameraPose == cameraPose) &&
            const DeepCollectionEquality()
                .equals(other._updatedPlanes, _updatedPlanes) &&
            const DeepCollectionEquality().equals(
                other._updatedAugmentedImages, _updatedAugmentedImages) &&
            const DeepCollectionEquality()
                .equals(other._lightEstimate, _lightEstimate) &&
            (identical(other.trackingFailureReason, trackingFailureReason) ||
                other.trackingFailureReason == trackingFailureReason));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      timestamp,
      cameraPose,
      const DeepCollectionEquality().hash(_updatedPlanes),
      const DeepCollectionEquality().hash(_updatedAugmentedImages),
      const DeepCollectionEquality().hash(_lightEstimate),
      trackingFailureReason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionFrameImplCopyWith<_$SessionFrameImpl> get copyWith =>
      __$$SessionFrameImplCopyWithImpl<_$SessionFrameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionFrameImplToJson(
      this,
    );
  }
}

abstract class _SessionFrame extends SessionFrame {
  const factory _SessionFrame(
      {required final DateTime timestamp,
      required final Pose cameraPose,
      final List<Plane> updatedPlanes,
      final List<AugmentedImage> updatedAugmentedImages,
      final Map<String, dynamic> lightEstimate,
      final String? trackingFailureReason}) = _$SessionFrameImpl;
  const _SessionFrame._() : super._();

  factory _SessionFrame.fromJson(Map<String, dynamic> json) =
      _$SessionFrameImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  Pose get cameraPose;
  @override
  List<Plane> get updatedPlanes;
  @override
  List<AugmentedImage> get updatedAugmentedImages;
  @override
  Map<String, dynamic> get lightEstimate;
  @override
  String? get trackingFailureReason;
  @override
  @JsonKey(ignore: true)
  _$$SessionFrameImplCopyWith<_$SessionFrameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LightEstimate _$LightEstimateFromJson(Map<String, dynamic> json) {
  return _LightEstimate.fromJson(json);
}

/// @nodoc
mixin _$LightEstimate {
  double get pixelIntensity => throw _privateConstructorUsedError;
  List<double> get colorCorrection => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LightEstimateCopyWith<LightEstimate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LightEstimateCopyWith<$Res> {
  factory $LightEstimateCopyWith(
          LightEstimate value, $Res Function(LightEstimate) then) =
      _$LightEstimateCopyWithImpl<$Res, LightEstimate>;
  @useResult
  $Res call({double pixelIntensity, List<double> colorCorrection});
}

/// @nodoc
class _$LightEstimateCopyWithImpl<$Res, $Val extends LightEstimate>
    implements $LightEstimateCopyWith<$Res> {
  _$LightEstimateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pixelIntensity = null,
    Object? colorCorrection = null,
  }) {
    return _then(_value.copyWith(
      pixelIntensity: null == pixelIntensity
          ? _value.pixelIntensity
          : pixelIntensity // ignore: cast_nullable_to_non_nullable
              as double,
      colorCorrection: null == colorCorrection
          ? _value.colorCorrection
          : colorCorrection // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LightEstimateImplCopyWith<$Res>
    implements $LightEstimateCopyWith<$Res> {
  factory _$$LightEstimateImplCopyWith(
          _$LightEstimateImpl value, $Res Function(_$LightEstimateImpl) then) =
      __$$LightEstimateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double pixelIntensity, List<double> colorCorrection});
}

/// @nodoc
class __$$LightEstimateImplCopyWithImpl<$Res>
    extends _$LightEstimateCopyWithImpl<$Res, _$LightEstimateImpl>
    implements _$$LightEstimateImplCopyWith<$Res> {
  __$$LightEstimateImplCopyWithImpl(
      _$LightEstimateImpl _value, $Res Function(_$LightEstimateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pixelIntensity = null,
    Object? colorCorrection = null,
  }) {
    return _then(_$LightEstimateImpl(
      pixelIntensity: null == pixelIntensity
          ? _value.pixelIntensity
          : pixelIntensity // ignore: cast_nullable_to_non_nullable
              as double,
      colorCorrection: null == colorCorrection
          ? _value._colorCorrection
          : colorCorrection // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LightEstimateImpl implements _LightEstimate {
  const _$LightEstimateImpl(
      {required this.pixelIntensity,
      required final List<double> colorCorrection})
      : _colorCorrection = colorCorrection;

  factory _$LightEstimateImpl.fromJson(Map<String, dynamic> json) =>
      _$$LightEstimateImplFromJson(json);

  @override
  final double pixelIntensity;
  final List<double> _colorCorrection;
  @override
  List<double> get colorCorrection {
    if (_colorCorrection is EqualUnmodifiableListView) return _colorCorrection;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_colorCorrection);
  }

  @override
  String toString() {
    return 'LightEstimate(pixelIntensity: $pixelIntensity, colorCorrection: $colorCorrection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LightEstimateImpl &&
            (identical(other.pixelIntensity, pixelIntensity) ||
                other.pixelIntensity == pixelIntensity) &&
            const DeepCollectionEquality()
                .equals(other._colorCorrection, _colorCorrection));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pixelIntensity,
      const DeepCollectionEquality().hash(_colorCorrection));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LightEstimateImplCopyWith<_$LightEstimateImpl> get copyWith =>
      __$$LightEstimateImplCopyWithImpl<_$LightEstimateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LightEstimateImplToJson(
      this,
    );
  }
}

abstract class _LightEstimate implements LightEstimate {
  const factory _LightEstimate(
      {required final double pixelIntensity,
      required final List<double> colorCorrection}) = _$LightEstimateImpl;

  factory _LightEstimate.fromJson(Map<String, dynamic> json) =
      _$LightEstimateImpl.fromJson;

  @override
  double get pixelIntensity;
  @override
  List<double> get colorCorrection;
  @override
  @JsonKey(ignore: true)
  _$$LightEstimateImplCopyWith<_$LightEstimateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
