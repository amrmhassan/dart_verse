// ignore_for_file: overridden_fields

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/features/email_verification/repo/email_verification_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';

import '../../../errors/models/auth_errors.dart';

class DefaultEmailVerificationProvider extends EmailVerificationProvider {
  @override
  String? emailTemplate;
  @override
  Duration? verifyLinkExpiresAfter;
  @override
  final Duration? allowNewJwtAfter;

  @override
  AuthService authService;

  DefaultEmailVerificationProvider({
    this.emailTemplate,
    this.verifyLinkExpiresAfter,
    this.allowNewJwtAfter,
    required this.authService,
  }) : super(
          template: emailTemplate,
          verifyLinkExpiresAfter: verifyLinkExpiresAfter,
          authService: authService,
          allowNewJwtAfter: allowNewJwtAfter,
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
    return authService.markUserAsVerified(jwt);
  }
}
