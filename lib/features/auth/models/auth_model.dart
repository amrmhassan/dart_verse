import 'dart:convert';

import 'package:auth_server/constants/model_fields.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  final String email;
  final String name;
  final String passwordHash;

  const AuthModel({
    required this.email,
    required this.name,
    required this.passwordHash,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthModelToJson(this);

  @override
  String toString() {
    var obj = toJson();
    obj.remove(ModelFields.passwordHash);
    return json.encode(obj);
  }
}
