// ignore_for_file: overridden_fields

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/features/email_verification/repo/email_verification_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';

import '../../../errors/models/auth_errors.dart';

class DefaultEmailVerificationProvider extends EmailVerificationProvider {
  @override
  String? template;
  @override
  Duration? verifyLinkExpiresAfter;
  @override
  final Duration? allowNewJwtAfter;

  @override
  JWTKey jwtKey;

  @override
  JWTAlgorithm algorithm;

  @override
  AuthService authService;

  DefaultEmailVerificationProvider({
    this.template,
    this.verifyLinkExpiresAfter,
    this.allowNewJwtAfter,
    required this.jwtKey,
    required this.algorithm,
    required this.authService,
  }) : super(
          template: template,
          verifyLinkExpiresAfter: verifyLinkExpiresAfter,
          jwtKey: jwtKey,
          algorithm: algorithm,
          authService: authService,
        );

  @override
  Future<String> createToken(String userId) async {
    return await authService.createVerifyEmailToken(
      userId,
      allowNewJwtAfter: allowNewJwtAfter,
      verifyLinkExpiresAfter: verifyLinkExpiresAfter,
    );
  }

  @override
  Future<void> verifyUser(String jwt) {
    // in here i should update the user from the database and make him verified
    var res = JWT.tryVerify(jwt, jwtKey);
    if (res == null) {
      throw JwtEmailVerificationExpired();
    }
    var payload = res.payload;
    var id = payload[ModelFields.id];
    if (id is! String) {
      throw UserNotFoundToVerify();
    }

    return authService.verifyUser(jwt, id);
  }
}
