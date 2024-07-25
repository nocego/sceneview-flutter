import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math_64.dart';
import '../enums/plane_type.dart';
import '../utils/vector_converter.dart';

part 'ar_hit_test_result.freezed.dart';
part 'ar_hit_test_result.g.dart';

@freezed
class ARHitTestResult with _$ARHitTestResult {
  const factory ARHitTestResult({
    @Vector3MapConverter() required Vector3 position,
    required PlaneType planeType,
  }) = _ARHitTestResult;

  factory ARHitTestResult.fromJson(Map<String, dynamic> json) =>
      _$ARHitTestResultFromJson(json);
}
