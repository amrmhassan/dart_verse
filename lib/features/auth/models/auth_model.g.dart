// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      email: json['email'] as String,
      name: json['name'] as String,
      passwordHash: json['passwordHash'] as String,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'passwordHash': instance.passwordHash,
    };
