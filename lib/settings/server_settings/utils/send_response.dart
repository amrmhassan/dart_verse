import 'dart:convert';

import 'package:shelf/shelf.dart';

class SendResponse {
  static Response sendDataToUser(
    String msg, {
    String? dataFieldName,
  }) {
    return Response.ok(json.encode({
      "msg": 'success',
      'code': 200,
      dataFieldName ?? 'data': msg,
    }));
  }

  static Response sendBadBodyErrorToUser(String e, String? code) {
    return Response.badRequest(
        body: json.encode({
      'error': e,
      'code': code,
    }));
  }

  static Response sendAuthErrorToUser(
    String e,
    String? code,
  ) {
    return Response.forbidden(json.encode({
      'error': e,
      'code': code,
    }));
  }

  static Response sendOtherExceptionErrorToUser(String e, String? code) {
    return Response.internalServerError(
        body: json.encode({
      'error': e,
      'code': code,
    }));
  }

  static Response sendUnknownError(String? code) {
    return sendOtherExceptionErrorToUser('unknown error occurred', code);
  }

  static Response sendForbidden(String message, String? code) {
    return Response.forbidden(json.encode({
      'msg': message,
      'code': code,
    }));
  }
}
