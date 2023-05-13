// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JWTPayloadModel _$JWTPayloadModelFromJson(Map<String, dynamic> json) =>
    JWTPayloadModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$JWTPayloadModelToJson(JWTPayloadModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
    };
