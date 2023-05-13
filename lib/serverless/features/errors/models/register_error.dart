import 'package:auth_server/serverless/features/errors/serverless_exception.dart';

class RegisterException implements ServerLessException {
  @override
  String message;

  RegisterException(this.message);
}
