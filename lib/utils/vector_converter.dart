import 'package:json_annotation/json_annotation.dart';
import 'package:vector_math/vector_math_64.dart';

class Vector2Converter implements JsonConverter<Vector2, List<double>> {
  const Vector2Converter();

  @override
  Vector2 fromJson(List<double> json) {
    if (json.length != 2) {
      throw const FormatException('Invalid Vector2 format');
    }
    return Vector2(json[0], json[1]);
  }

  @override
  List<double> toJson(Vector2 object) => [object.x, object.y];
}

class Vector3Converter implements JsonConverter<Vector3, List<double>> {
  const Vector3Converter();

  @override
  Vector3 fromJson(List<double> json) {
    if (json.length != 3) {
      throw const FormatException('Invalid Vector3 format');
    }
    return Vector3(json[0], json[1], json[2]);
  }

  @override
  List<double> toJson(Vector3 object) => [object.x, object.y, object.z];
}

class Vector4Converter implements JsonConverter<Vector4, List<double>> {
  const Vector4Converter();

  @override
  Vector4 fromJson(List<double> json) {
    if (json.length != 4) {
      throw const FormatException('Invalid Vector4 format');
    }
    return Vector4(json[0], json[1], json[2], json[3]);
  }

  @override
  List<double> toJson(Vector4 object) =>
      [object.x, object.y, object.z, object.w];
}

class QuaternionConverter implements JsonConverter<Quaternion, List<double>> {
  const QuaternionConverter();

  @override
  Quaternion fromJson(List<double> json) {
    if (json.length != 4) {
      throw const FormatException('Invalid Quaternion format');
    }
    return Quaternion(json[0], json[1], json[2], json[3]);
  }

  @override
  List<double> toJson(Quaternion object) =>
      [object.x, object.y, object.z, object.w];
}

class Matrix3Converter implements JsonConverter<Matrix3, List<double>> {
  const Matrix3Converter();

  @override
  Matrix3 fromJson(List<double> json) {
    if (json.length != 9) {
      throw const FormatException('Invalid Matrix3 format');
    }
    return Matrix3(
      json[0],
      json[1],
      json[2],
      json[3],
      json[4],
      json[5],
      json[6],
      json[7],
      json[8],
    );
  }

  @override
  List<double> toJson(Matrix3 object) => object.storage;
}

class Matrix4Converter implements JsonConverter<Matrix4, List<double>> {
  const Matrix4Converter();

  @override
  Matrix4 fromJson(List<double> json) {
    if (json.length != 16) {
      throw const FormatException('Invalid Matrix4 format');
    }
    return Matrix4.fromList(json);
  }

  @override
  List<double> toJson(Matrix4 object) => object.storage;
}
