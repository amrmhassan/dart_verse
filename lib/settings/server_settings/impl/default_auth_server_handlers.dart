import 'dart:convert';

import 'package:dart_verse/errors/models/auth_errors.dart';
import 'package:dart_verse/errors/models/server_errors.dart';
import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_handlers.dart';
import 'package:shelf/shelf.dart';

import '../repo/auth_body_keys.dart';

class DefaultAuthServerHandlers implements AuthServerHandlers {
  Future _wrapper(Request request,
      Future Function(Map<String, dynamic> body) method) async {
    try {
      String body = await request.readAsString();
      if (body.isEmpty) {
        throw RequestBodyError();
      }
      Map<String, dynamic> data = json.decode(body);

      return await method(data);
    } on ServerException catch (e) {
      return _sendBadBodyErrorToUser(e.message);
    } on AuthException catch (e) {
      return _sendAuthErrorToUser(e.message);
    } on ServerLessException catch (e) {
      return _sendOtherExceptionErrorToUser(e.message);
    } catch (e) {
      return _sendOtherExceptionErrorToUser('unknown error occurred');
    }
  }

  @override
  login(Request request) async {
    return _wrapper(
      request,
      (data) async {
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
      request,
      (data) async {
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
    return Response.ok(json.encode({
      "msg": 'success',
      'code': 200,
      'jwt': jwt,
    }));
  }

  _sendBadBodyErrorToUser(String e) {
    return Response.badRequest(
        body: json.encode({
      'error': e,
    }));
  }

  _sendAuthErrorToUser(String e) {
    return Response.forbidden(json.encode({
      'error': e,
    }));
  }

  _sendOtherExceptionErrorToUser(String e) {
    return Response.internalServerError(
        body: json.encode({
      'error': e,
    }));
  }
}
