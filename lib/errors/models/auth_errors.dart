// ignore_for_file: overridden_fields

import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:googleapis/servicemanagement/v1.dart';

//# auth exceptions
class AuthException extends ServerLessException {
  @override
  String message;
  AuthException(this.message);
}

//? register exceptions
class RegisterUserException extends AuthException {
  @override
  String message;

  RegisterUserException(this.message) : super(message);
}

//? jwt auth errors
class JwtAuthException extends AuthException {
  @override
  String message;

  JwtAuthException(this.message) : super(message);
}

class DuplicateEmailException extends RegisterUserException {
  DuplicateEmailException() : super('email already exists');
}

//? login exceptions
class LoginUserException extends AuthException {
  @override
  String message;

  LoginUserException(this.message) : super(message);
}

class NoUserRegisteredException extends LoginUserException {
  NoUserRegisteredException() : super('no user registered');
}

class InvalidPassword extends LoginUserException {
  InvalidPassword() : super('invalid password');
}

class LoginExceedException extends LoginUserException {
  LoginExceedException()
      : super(
            'logged in too much, too much active sessions, try logging out from all of your devices');
}

//? jwt actual exceptions
class NoAuthHeaderException extends JwtAuthException {
  NoAuthHeaderException()
      : super('please provide the `authorization` in headers');
}

class AuthHeaderNotValidException extends JwtAuthException {
  AuthHeaderNotValidException() : super('authorization header is not valid');
}

class ProvidedJwtNotValid extends JwtAuthException {
  ProvidedJwtNotValid() : super('provided jwt is not valid');
}
