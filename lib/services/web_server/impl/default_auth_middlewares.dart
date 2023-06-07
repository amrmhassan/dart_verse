import 'dart:async';

import 'package:dart_express/dart_express.dart';
import 'package:dart_express/dart_express/server/repo/passed_http_entity.dart';
import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/web_server/repo/auth_middlewares.dart';
import 'package:dart_verse/settings/app/app.dart';

import '../../../constants/context_fields.dart';
import '../../../constants/header_fields.dart';
import '../../../errors/models/auth_errors.dart';
import '../../../settings/server_settings/utils/send_response.dart';

class DefaultAuthMiddlewares implements AuthServerMiddlewares {
  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future<PassedHttpEntity> Function() method,
  ) async {
    try {
      return await method();
    } on JwtAuthException catch (e) {
      return SendResponse.sendForbidden(response, e.message, e.code);
    } on ServerLessException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(response, e.message, e.code);
    } catch (e) {
      return SendResponse.sendUnknownError(response, null);
    }
  }

  @override
  FutureOr<PassedHttpEntity> checkJwtForUserId(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      var context = request.context;
      var jwtString = context[ContextFields.jwt];
      if (jwtString is! String) {
        throw ProvidedJwtNotValid(4);
      }

      var res = await authService.loginWithJWT(jwtString);
      if (!res) {
        throw AuthNotAllowedException();
      }
      return request;
    });
  }

  // {
  //   return (request) async {
  //     return _wrapper(() async {
  //       var context = request.context;
  //       var jwtString = context[ContextFields.jwt];
  //       if (jwtString is! String) {
  //         throw ProvidedJwtNotValid(4);
  //       }

  //       var res = await authService.loginWithJWT(jwtString);
  //       if (!res) {
  //         throw AuthNotAllowedException();
  //       }
  //       return innerHandler(request);
  //     });
  //   };
  // }

  @override
  FutureOr<PassedHttpEntity> checkJwtInHeaders(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      var headers = request.headers;
      var jwt = headers.value(HeaderFields.authorization);
      if (jwt == null) {
        throw NoAuthHeaderException();
      }
      jwt = jwt.toString();
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
      request.context[ContextFields.jwt] = jwtString;

      // var changedRequest = request.change(context: {
      //   ContextFields.jwt: jwtString,
      // });
      return request;
    });
  }

  // {
  //   return (request) {
  //     return _wrapper(() async {
  //       var headers = request.headers;
  //       final jwt = headers[HeaderFields.authorization];
  //       if (jwt == null) {
  //         throw NoAuthHeaderException();
  //       }
  //       var parts = jwt.split(' ');
  //       int length = parts.length;
  //       String bearer = parts.first;
  //       String jwtString = parts.last;
  //       if (length != 2) {
  //         throw AuthHeaderNotValidException();
  //       }
  //       if (bearer != HeaderFields.bearer) {
  //         throw AuthHeaderNotValidException();
  //       }
  //       if (jwtString.isEmpty) {
  //         throw ProvidedJwtNotValid(1);
  //       }

  //       var changedRequest = request.change(context: {
  //         ContextFields.jwt: jwtString,
  //       });
  //       return innerHandler(changedRequest);
  //     });
  //   };
  // }

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

  @override
  FutureOr<PassedHttpEntity> checkAppId(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      var allowedAppIds =
          authService.authDbProvider.app.authSettings.allowedAppsIds;
      // to skip checking app ids if null
      if (allowedAppIds == null) return request;
      String? appId = request.headers.value(HeaderFields.appId);

      if (appId == null) {
        throw NoAppIdException();
      }
      if (!allowedAppIds.any((element) => element == appId)) {
        throw NonAuthorizedAppId();
      }
      return request;
    });
  }
}
