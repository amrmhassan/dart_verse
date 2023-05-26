// ignore_for_file: overridden_fields, annotate_overrides

import 'package:dart_verse/errors/serverless_exception.dart';

import '../../services/web_server/repo/error_codes.dart';

class ServerException extends ServerLessException {
  @override
  String message;
  final String code;

  ServerException(this.message, this.code) : super(code);
}

//? server exceptions

class NoRouterSetException extends ServerException {
  NoRouterSetException()
      : super(
          'please add at least one pipeline to the service before running server',
          ErrorCodes.noRouterSet,
        );
}

class NoAuthServerSettingsException extends ServerException {
  NoAuthServerSettingsException()
      : super(
          'once you allow for auto auth for the server you must provide auth server settings try the DefaultAuthServerSettings or implement your own ',
          ErrorCodes.noAuthServerSettings,
        );
}

class RequestBodyError extends ServerException {
  RequestBodyError()
      : super(
          'bad body data, please check documentation',
          ErrorCodes.requestBoyError,
        );
}
