import 'package:dart_verse/serverless/settings/defaults/default_auth_settings.dart';

class AuthSettings {
  /// this is the collection name of the auth table(collection) that you want to save users auth info in
  final String collectionName;

  /// this will be used to allow duplicate emails so you can use multi providers(facebook, email, google, etc...)
  final bool allowDuplicateEmails;

  /// the jwt will expire after this duration so the user must login again for a new jwt
  final Duration authExpireAfter;

  /// this is the jwt secret key  `[Must be stored in a safe place]`
  final String jwtSecretKey;

  /// this is the collection name for the active tokens of the user to keep track of all user sessions
  final String activeJWTCollName;

  const AuthSettings({
    required this.jwtSecretKey,
    this.collectionName = DefaultAuthSettings.collectionName,
    this.allowDuplicateEmails = DefaultAuthSettings.allowDuplicateEmails,
    this.authExpireAfter = DefaultAuthSettings.authExpireAfter,
    this.activeJWTCollName = DefaultAuthSettings.activeTokensCollName,
  });
}
