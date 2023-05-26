import 'dart:convert';

import 'package:dart_verse/errors/models/auth_errors.dart';
import 'package:dart_verse/errors/models/server_errors.dart';
import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_handlers.dart';
import 'package:shelf/shelf.dart';

import '../repo/auth_body_keys.dart';
import '../utils/send_response.dart';

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
      return SendResponse.sendBadBodyErrorToUser(e.message);
    } on AuthException catch (e) {
      return SendResponse.sendAuthErrorToUser(e.message);
    } on ServerLessException catch (e) {
      return SendResponse.sendOtherExceptionErrorToUser(e.message);
    } catch (e) {
      return SendResponse.sendUnknownError();
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
        return SendResponse.sendDataToUser(jwt, dataFieldName: 'jwt');
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
        return SendResponse.sendDataToUser(jwt, dataFieldName: 'jwt');
      },
    );
  }

  @override
  AuthService authService;

  @override
  AuthBodyKeys defaultAuthBodyKeys;

  DefaultAuthServerHandlers(this.authService, this.defaultAuthBodyKeys);
}
