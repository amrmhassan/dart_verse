import 'dart:convert';
import 'dart:io';

import 'package:dart_express/dart_express.dart';

class SendResponse {
  static ResponseHolder sendDataToUser(
    ResponseHolder response,
    String msg, {
    String? dataFieldName,
  }) {
    return response.writeJson({
      "msg": 'success',
      'code': 200,
      dataFieldName ?? 'data': msg,
    });
  }

  static ResponseHolder sendBadBodyErrorToUser(
    ResponseHolder response,
    String e,
    String? code,
  ) {
    return response.writeJson({
      'error': e,
      'code': code,
    });
  }

  static ResponseHolder sendAuthErrorToUser(
    ResponseHolder response,
    String e,
    String? code,
  ) {
    return response.writeJson({
      'error': e,
      'code': code,
    });
  }

  static ResponseHolder sendOtherExceptionErrorToUser(
    ResponseHolder response,
    String e,
    String? code,
  ) {
    return response.writeJson({
      'error': e,
      'code': code,
    });
  }

  static ResponseHolder sendUnknownError(
    ResponseHolder response,
    String? code,
  ) {
    return sendOtherExceptionErrorToUser(
        response, 'unknown error occurred', code);
  }

  static ResponseHolder sendForbidden(
    ResponseHolder response,
    String message,
    String? code,
  ) {
    return response.writeJson({
      'msg': message,
      'code': code,
    });
  }
}
