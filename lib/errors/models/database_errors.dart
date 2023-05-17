import 'package:dart_verse/errors/serverless_exception.dart';

class DBException implements ServerLessException {
  @override
  String message;
  DBException(this.message);
}

//? db exceptions
class DBReadException implements DBException {
  @override
  String message;

  DBReadException(this.message);
}

class DBWriteException implements DBException {
  @override
  String message;

  DBWriteException(this.message);
}

class DbDocValidationException implements DBException {
  @override
  String message;

  DbDocValidationException(this.message);
}
