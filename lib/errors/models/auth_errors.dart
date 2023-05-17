import 'package:dart_verse/errors/serverless_exception.dart';

//# auth exceptions
class AuthException implements ServerLessException {
  @override
  String message;
  AuthException(this.message);
}

//? register exceptions
class RegisterUserException implements AuthException {
  @override
  String message;

  RegisterUserException(this.message);
}

class DuplicateEmailException implements RegisterUserException {
  @override
  String message = 'email already exists';
}

//? login exceptions
class LoginUserException implements AuthException {
  @override
  String message;

  LoginUserException(this.message);
}

class NoUserRegistered implements LoginUserException {
  @override
  String message = 'no user registered';
}

class InvalidPassword implements LoginUserException {
  @override
  String message = 'invalid password';
}
