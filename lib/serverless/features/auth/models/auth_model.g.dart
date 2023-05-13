// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthModel _$AuthModelFromJson(Map<String, dynamic> json) => AuthModel(
      id: json['userId'] as String,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String,
      jwt: json['jwt'] as String,
    );

Map<String, dynamic> _$AuthModelToJson(AuthModel instance) => <String, dynamic>{
      'email': instance.email,
      'userId': instance.id,
      'passwordHash': instance.passwordHash,
      'jwt': instance.jwt,
    };
