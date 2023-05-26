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

  static Response sendBadBodyErrorToUser(String e) {
    return Response.badRequest(
        body: json.encode({
      'error': e,
    }));
  }

  static Response sendAuthErrorToUser(String e) {
    return Response.forbidden(json.encode({
      'error': e,
    }));
  }

  static Response sendOtherExceptionErrorToUser(String e) {
    return Response.internalServerError(
        body: json.encode({
      'error': e,
    }));
  }

  static Response sendUnknownError() {
    return sendOtherExceptionErrorToUser('unknown error occurred');
  }
}
