import 'dart:async';

import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/web_server/repo/auth_middlewares.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:shelf/shelf.dart';

import '../../../constants/context_fileds.dart';
import '../../../constants/header_fields.dart';
import '../../../errors/models/auth_errors.dart';
import '../../../settings/server_settings/utils/send_response.dart';

class DefaultAuthMiddlewares implements AuthServerMiddlewares {
  Future<Response> _wrapper(Future Function() method) async {
    try {
      return await method();
    } on JwtAuthException catch (e) {
      return SendResponse.sendForbidden(e.message, e.code);
    } on ServerLessException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(e.message, e.code);
    } catch (e) {
      return SendResponse.sendUnknownError(null);
    }
  }

  @override
  FutureOr<Response> Function(Request request) checkJwtForUserId(
      FutureOr<Response> Function(Request request) innerHandler) {
    return (request) async {
      return _wrapper(() async {
        var context = request.context;
        var jwtString = context[ContextFields.jwt];
        if (jwtString is! String) {
          throw ProvidedJwtNotValid(4);
        }

        var res = await authService.loginWithJWT(jwtString);
        if (!res) {
          throw AuthNotAllowedException();
        }
        return innerHandler(request);
      });
    };
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
          throw ProvidedJwtNotValid(1);
        }

        var changedRequest = request.change(context: {
          ContextFields.jwt: jwtString,
        });
        return innerHandler(changedRequest);
      });
    };
  }

  // @override
  // FutureOr<Response> Function(Request request) checkJwtValid(
  //     FutureOr<Response> Function(Request request) innerHandler) {
  //   return (request) {
  //     return _wrapper(() async {
  //       var context = request.context;
  //       var jwtString = context[ContextFields.jwt];
  //       if (jwtString is! String) {
  //         throw ProvidedJwtNotValid(2);
  //       }

  //       var res =
  //           JWT.tryVerify(jwtString, SecretKey(app.authSettings.jwtSecretKey));
  //       if (res == null) {
  //         throw ProvidedJwtNotValid(3);
  //       }
  //       var payload = res.payload;
  //       if (payload is! Map) {
  //         throw UserDataException();
  //       }
  //       var changedRequest = request.change(context: {
  //         ContextFields.jwtPayload: payload,
  //       });

  //       return innerHandler(changedRequest);
  //     });
  //   };
  // }

  @override
  late AuthService authService;
  @override
  late App app;
  DefaultAuthMiddlewares(this.authService, this.app);
}
