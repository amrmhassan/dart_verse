import 'dart:async';

import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/web_server/repo/auth_middlewares.dart';
import 'package:shelf/shelf.dart';

import '../../../constants/context_fileds.dart';
import '../../../constants/header_fields.dart';
import '../../../errors/models/auth_errors.dart';
import '../../../settings/server_settings/utils/send_response.dart';

class DefaultAuthMiddlewares implements AuthServerMiddlewares {
  Future<Response> _wrapper(Future Function() method) async {
    try {
      return await method();
    } on ServerLessException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(e.message);
    } catch (e) {
      return SendResponse.sendUnknownError();
    }
  }

  @override
  FutureOr<Response> Function(Request request) checkJwtForUserId(
      FutureOr<Response> Function(Request request) innerHandler) {
    return innerHandler;
  }

  @override
  FutureOr<Response> Function(Request request) checkJwtInHeaders(
      FutureOr<Response> Function(Request request) innerHandler) {
    return (request) {
      return _wrapper(() async {
        var headers = request.headers;
        final jwt = headers[HeaderFields.authorization];
        if (jwt == null) {
          throw NoAuthHeaderException();
        }
        var parts = jwt.split(' ');
        int length = parts.length;
        String bearer = parts.first;
        String jwtString = parts.last;
        if (length != 2) {
          throw AuthHeaderNotValidException();
        }
        if (bearer != HeaderFields.bearer) {
          throw AuthHeaderNotValidException();
        }
        if (jwtString.isEmpty) {
          throw ProvidedJwtNotValid();
        }

        var changedRequest = request.change(context: {
          ContextFields.jwt: jwtString,
        });
        return innerHandler(changedRequest);
      });
    };
  }

  @override
  FutureOr<Response> Function(Request request) checkJwtValid(
      FutureOr<Response> Function(Request request) innerHandler) {
    return (request) {
      var context = request.context;
      var jwtString = context[ContextFields.jwt];
      if (jwtString is! String) {
        throw ProvidedJwtNotValid();
      }

      print(jwtString);
      return innerHandler(request);
    };
  }

  @override
  late AuthService authService;
  DefaultAuthMiddlewares(this.authService);
}
