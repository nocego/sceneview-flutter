// lib/models/session_frame.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'plane.dart';

part 'session_frame.freezed.dart';
part 'session_frame.g.dart';

@freezed
class SessionFrame with _$SessionFrame {
  const factory SessionFrame({
    required List<Plane> planes,
  }) = _SessionFrame;

  factory SessionFrame.fromJson(Map<String, dynamic> json) => SessionFrame(
        planes: (json['planes'] as List<dynamic>)
            .map((planeJson) =>
                Plane.fromJson(planeJson as Map<String, dynamic>))
            .toList(),
      );
}
