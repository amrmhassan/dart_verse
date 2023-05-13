import 'package:auth_server/serverless/settings/auth_settings/default_auth_settings.dart';

class AuthSettings {
  final String collectionName;

  /// this will be used to allow duplicate emails so you can use multi providers(facebook, email, google, etc...)
  final bool allowDuplicateEmails;

  /// the jwt will expire after this duration so the user must login again for a new jwt
  final Duration authExpireAfter;

  /// ths jwt secret key  `[Must be stored in a safe place]`
  final String jwtSecretKey;
  const AuthSettings({
    required this.jwtSecretKey,
    this.collectionName = DefaultAuthSettings.collectionName,
    this.allowDuplicateEmails = DefaultAuthSettings.allowDuplicateEmails,
    this.authExpireAfter = DefaultAuthSettings.authExpireAfter,
  });
}
