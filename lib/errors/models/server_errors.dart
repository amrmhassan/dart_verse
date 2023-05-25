// ignore_for_file: overridden_fields

import 'package:dart_verse/errors/serverless_exception.dart';

class ServerException extends ServerLessException {
  @override
  String message;
  ServerException(this.message);
}

//? server exceptions
class NoServerSettingsExceptions extends ServerException {
  NoServerSettingsExceptions() : super('no serverSettings provided');
}

class NoRouterSetException extends ServerException {
  NoRouterSetException()
      : super(
            'please add at least one pipeline to the service before running server');
}

class NoAuthServerSettingsException extends ServerException {
  NoAuthServerSettingsException()
      : super(
            'once you allow for auto auth for the server you must provide auth server settings try the DefaultAuthServerSettings or implement your own ');
}

class RequestBodyError extends ServerException {
  RequestBodyError() : super('bad body data, please check documentation');
}
