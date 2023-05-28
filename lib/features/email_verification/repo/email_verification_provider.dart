//! add the verified property to the auth model
//! i will use jwt to create the token for email verification and add the
//! expiry date to the json web token

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/services/auth/auth_service.dart';

abstract class EmailVerificationProvider {
  final String? template;
  final Duration? verifyLinkExpiresAfter;

  /// this will restrict user to allow for a new jwt after a specific amount of time
  //! just add the code for this
  final Duration? allowNewJwtAfter;
  final JWTKey jwtKey;
  final JWTAlgorithm algorithm;
  final AuthService authService;

  EmailVerificationProvider({
    this.template,
    this.verifyLinkExpiresAfter,
    required this.jwtKey,
    required this.algorithm,
    required this.authService,
    this.allowNewJwtAfter,
  });

  Future<String> createToken(String userId);
  Future<void> verifyUser(String jwt);
}
