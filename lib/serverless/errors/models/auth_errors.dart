import 'package:dart_verse/serverless/errors/serverless_exception.dart';

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
  String message = 'Email already exists';
}
