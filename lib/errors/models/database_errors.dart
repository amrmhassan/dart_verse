import 'package:dart_verse/errors/serverless_exception.dart';

class DBException extends ServerLessException {
  @override
  String message;
  DBException(this.message);
}

//? db exceptions
class DBReadException extends DBException {
  @override
  String message;

  DBReadException(this.message) : super(message);
}

class DBWriteException extends DBException {
  @override
  String message;

  DBWriteException(this.message) : super(message);
}

class DbDocValidationException extends DBException {
  @override
  String message;

  DbDocValidationException(this.message) : super(message);
}
