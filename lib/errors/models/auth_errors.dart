// ignore_for_file: overridden_fields

import 'package:dart_verse/errors/serverless_exception.dart';

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
