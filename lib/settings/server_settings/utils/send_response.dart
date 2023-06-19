import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';

class SendResponse {
  static ResponseHolder sendDataToUser(
    ResponseHolder response,
    String msg, {
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
    String? code,
  ) {
    return response.writeJson(
      {
        'error': e,
        'code': code,
      },
      code: 400,
    );
  }

  static ResponseHolder sendAuthErrorToUser(
    ResponseHolder response,
    String e,
    String? code,
  ) {
    return response.writeJson(
      {
        'error': e,
        'code': code,
      },
      code: 401,
    );
  }

  static ResponseHolder sendOtherExceptionErrorToUser(
    ResponseHolder response,
    String e,
    String? code,
  ) {
    return response.writeJson(
      {
        'error': e,
        'code': code,
      },
      code: 500,
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
    String? code,
  ) {
    return response.writeJson(
      {
        'msg': message,
        'code': code,
      },
      code: 403,
    );
  }
}
