// ignore_for_file: overridden_fields

import 'package:dart_verse/errors/serverless_exception.dart';

import '../../services/web_server/repo/error_codes.dart';

//# auth exceptions
class AuthException extends ServerLessException {
  @override
  String message;
  @override
  String code;
  AuthException(this.message, this.code) : super(code);
}

//? register exceptions
class RegisterUserException extends AuthException {
  @override
  String message;
  @override
  String code;

  RegisterUserException(this.message, this.code) : super(message, code);
}

//? jwt auth errors
class JwtAuthException extends AuthException {
  @override
  String message;
  @override
  String code;

  JwtAuthException(this.message, this.code) : super(message, code);
}

class DuplicateEmailException extends RegisterUserException {
  DuplicateEmailException()
      : super(
          'email already exists',
          ErrorCodes.duplicateEmail,
        );
}

//? login exceptions
class LoginUserException extends AuthException {
  @override
  String message;
  @override
  String code;

  LoginUserException(this.message, this.code)
      : super(
          message,
          code,
        );
}

class NoUserRegisteredException extends LoginUserException {
  NoUserRegisteredException()
      : super(
          'no user registered',
          ErrorCodes.noUserRegistered,
        );
}

class InvalidPassword extends LoginUserException {
  InvalidPassword()
      : super(
          'invalid password',
          ErrorCodes.invalidPassword,
        );
}

class LoginExceedException extends LoginUserException {
  LoginExceedException()
      : super(
          'logged in too much, too much active sessions, try logging out from all of your devices',
          ErrorCodes.activeJwtExceed,
        );
}

//? jwt actual exceptions
class NoAuthHeaderException extends JwtAuthException {
  NoAuthHeaderException()
      : super(
          'please provide the `authorization` in headers',
          ErrorCodes.noAuthHeaderProvided,
        );
}

class AuthHeaderNotValidException extends JwtAuthException {
  AuthHeaderNotValidException()
      : super(
          'authorization header is not valid',
          ErrorCodes.authHeaderNotValid,
        );
}

class ProvidedJwtNotValid extends JwtAuthException {
  ProvidedJwtNotValid(int code)
      : super(
          'provided jwt is not valid with type: $code',
          ErrorCodes.jwtNotValid,
        );
}

class AuthNotAllowedException extends JwtAuthException {
  AuthNotAllowedException()
      : super(
          'auth operation not allowed',
          ErrorCodes.jwtAccessNotAllowed,
        );
}

class JwtEmailVerificationExpired extends JwtAuthException {
  JwtEmailVerificationExpired()
      : super(
          'the token is expired, try get a new one',
          ErrorCodes.jwtEmailVerifyExpired,
        );
}

class UserNotFoundToVerify extends JwtAuthException {
  UserNotFoundToVerify()
      : super(
          'can\'t find the user to verify',
          ErrorCodes.userNotFoundToVerify,
        );
}

class NoAppIdException extends JwtAuthException {
  NoAppIdException()
      : super(
          'please provide your app id in the headers as appid:<put_your_app_id_here>',
          ErrorCodes.noAppIdProvided,
        );
}

class NonAuthorizedAppId extends JwtAuthException {
  NonAuthorizedAppId()
      : super(
          'the provided app id isn\'t authorized',
          ErrorCodes.notAuthorizedAppId,
        );
}
