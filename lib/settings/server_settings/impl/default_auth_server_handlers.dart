import 'dart:convert';

import 'package:dart_verse/errors/models/auth_errors.dart';
import 'package:dart_verse/errors/models/server_errors.dart';
import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_handlers.dart';
import 'package:shelf/shelf.dart';

import '../repo/auth_body_keys.dart';

class DefaultAuthServerHandlers implements AuthServerHandlers {
  Future _wrapper(Future Function() method) async {
    try {
      await method();
    } on ServerException catch (e) {
      _sendBadBodyErrorToUser(e.message);
    } on AuthException catch (e) {
      _sendAuthErrorToUser(e.message);
    } on ServerLessException catch (e) {
      _sendOtherExceptionErrorToUser(e.message);
    } catch (e) {
      _sendOtherExceptionErrorToUser('unknown error occurred');
    }
  }

  @override
  login(Request request) async {
    return _wrapper(
      () async {
        String body = await request.readAsString();

        Map<String, dynamic> data = json.decode(body);
        String emailKey = defaultAuthBodyKeys.email;
        String passwordKey = defaultAuthBodyKeys.password;
        String? email = data[emailKey];
        String? password = data[passwordKey];
        if (email == null || password == null) {
          throw RequestBodyError();
        }

        String jwt = await authService.loginWithEmail(
          email: email,
          password: password,
        );
        return _sendJwtToUser(jwt);
      },
    );
  }

  @override
  register(Request request) async {
    return _wrapper(
      () async {
        String body = await request.readAsString();

        Map<String, dynamic> data = json.decode(body);
        String emailKey = defaultAuthBodyKeys.email;
        String passwordKey = defaultAuthBodyKeys.password;
        String userDataKey = defaultAuthBodyKeys.userData;

        String? email = data[emailKey];
        String? password = data[passwordKey];
        Map<String, dynamic>? userData = data[userDataKey];

        if (email == null || password == null) {
          throw RequestBodyError();
        }

        String jwt = await authService.registerUser(
          email: email,
          password: password,
          userData: userData,
        );
        return _sendJwtToUser(jwt);
      },
    );
  }

  @override
  AuthService authService;

  @override
  AuthBodyKeys defaultAuthBodyKeys;

  DefaultAuthServerHandlers(this.authService, this.defaultAuthBodyKeys);

  _sendJwtToUser(String jwt) {
    return Response.ok({
      "msg": 'success',
      'code': 200,
      'jwt': jwt,
    });
  }

  _sendBadBodyErrorToUser(String e) {
    return Response.badRequest(body: {
      'error': e,
    });
  }

  _sendAuthErrorToUser(String e) {
    return Response.forbidden({
      'error': e,
    });
  }

  _sendOtherExceptionErrorToUser(String e) {
    return Response.internalServerError(body: {
      'error': e,
    });
  }
}
