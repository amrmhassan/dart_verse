import 'package:dart_verse/errors/serverless_exception.dart';

class DBException implements ServerLessException {
  @override
  String message;
  DBException(this.message);
}

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
