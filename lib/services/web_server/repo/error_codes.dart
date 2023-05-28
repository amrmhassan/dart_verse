class ErrorCodes {
  //? app error codes
  static const String noDbSettingsCode = 'no-db-settings-provided';
  static const String noMongoDbProvider = 'no-mongo-db-provider';
  static const String noMemoryDbProvider = 'no-memory-db-provider';
  static const String noAuthSettings = 'no-auth-settings-provided';
  static const String noServerSettings = 'no-server-settings-provided';
  static const String noUserDataSettings = 'no-user-data-settings-provided';
  static const String noEmailSettings = 'no-email-settings-provided';
  //? server error codes
  static const String noRouterSet = 'no-router-set';
  static const String requestBoyError = 'no-body-provided';
  static const String noAuthServerSettings = 'no-auth-server-settings';
  //? user data error codes
  static const String userDataAuthService =
      'user-data-service-depend-on-auth-service';
  //? db error codes
  static const String dbReadCode = 'db-read-error';
  static const String dbWriteCode = 'db-write-error';
  static const String dbDocValidation = 'db-doc-validation';
  static const String mongoDbNotInitialized = 'mongo-db-not-initialized';
  static const String dbNotConnoted = 'db-not-connected';
  static const String dbAlreadyConnoted = 'db-already-connected';
  //? auth errors
  static const String duplicateEmail = 'duplicate-email-register';
  static const String noUserRegistered = 'no-user-registered';
  static const String invalidPassword = 'invalid-password-login';
  static const String activeJwtExceed = 'many-active-sessions';
  static const String noAuthHeaderProvided = 'no-auth-header';
  static const String authHeaderNotValid = 'auth-header-not-valid';
  static const String jwtNotValid = 'jwt-not-valid';
  static const String jwtAccessNotAllowed = 'jwt-access-not-allowed';
  static const String jwtEmailVerifyExpired = 'jwt-email-verify-expired';
  static const String userNotFoundToVerify = 'user-not-found-to-verify';

  //? email errors
  static const String emailTemplateFileNotFound =
      'email-template-file-not-found';
  //? email verification errors
  static const String failedToVerify = 'failed-to-verify';
  static const String earlyEmailVerification = 'early-email-verification';
  static const String userAlreadyVerified = 'user-already-verified';
}
