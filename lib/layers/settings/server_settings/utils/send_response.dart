import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';

class SendResponse {
  static ResponseHolder sendDataToUser(
    ResponseHolder response,
    dynamic msg, {
    String? dataFieldName,
  }) {
    return response.writeJson(
      {
        "msg": 'success',
        'code': 200,
        dataFieldName ?? 'data': msg,
      },
      code: 200,
    );
  }

  static ResponseHolder sendBadBodyErrorToUser(
    ResponseHolder response,
    String e,
    String? code, {
    int errorCode = 400,
  }) {
    return response.writeJson(
      {
        'error': e,
        'code': code,
      },
      code: errorCode,
    );
  }

  static ResponseHolder sendAuthErrorToUser(
    ResponseHolder response,
    String e,
    String? code, {
    int errorCode = 401,
  }) {
    return response.writeJson(
      {
        'error': e,
        'code': code,
      },
      code: errorCode,
    );
  }

  static ResponseHolder sendOtherExceptionErrorToUser(
    ResponseHolder response,
    String e,
    String? code, {
    int errorCode = 500,
  }) {
    return response.writeJson(
      {
        'error': e,
        'code': code,
      },
      code: errorCode,
    );
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
    String? code, {
    int errorCode = 403,
  }) {
    return response.writeJson(
      {
        'msg': message,
        'code': code,
      },
      code: errorCode,
    );
  }
}
