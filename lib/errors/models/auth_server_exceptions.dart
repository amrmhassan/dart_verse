// ignore_for_file: overridden_fields

import 'dart:io';

import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/layers/services/web_server/repo/error_codes.dart';

class AuthServerExceptions extends ServerLessException {
  @override
  String message;
  @override
  final String code;
  @override
  int errorCode;

  AuthServerExceptions(
    this.message,
    this.code, {
    this.errorCode = HttpStatus.badRequest,
  }) : super(code, errorCode: errorCode);
}

class NoAuthServerSettings extends AuthServerExceptions {
  NoAuthServerSettings()
      : super(
          'please provider authServer to ServerService',
          ErrorCodes.noAuthServerProvided,
        );
}
