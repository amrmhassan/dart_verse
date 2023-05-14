import 'package:dart_verse/serverless/errors/serverless_exception.dart';

class RegisterException implements ServerLessException {
  @override
  String message;

  RegisterException(this.message);
}
