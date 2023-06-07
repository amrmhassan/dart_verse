import 'dart:async';
import 'dart:io';

import 'package:dart_express/dart_express.dart';
import 'package:dart_verse/settings/app/app.dart';

import '../../errors/models/server_errors.dart';
import '../../settings/server_settings/repo/auth_server_settings.dart';

class ServerService {
  final App _app;
  final AuthServerSettings? _authServerSettings;

  ServerService(
    this._app, {
    AuthServerSettings? authServerSettings,
  }) : _authServerSettings = authServerSettings {
    _cascade = Cascade();
  }

  late Cascade _cascade;

  Future<HttpServer> runServer() async {
    InternetAddress ip = _app.serverSettings.ip;
    int port = _app.serverSettings.port;
    _addAuthEndpoints();
    ServerHolder serverHolder = ServerHolder(_cascade).addGlobalMiddleware(
      authServerSettings.authServerMiddlewares.checkAppId,
    );
    var server = await serverHolder.bind(ip, port);
    return server;
  }

  ServerService addPipeline(
    Pipeline pipeline, {
    bool jwtSecured = false,
    String? idFieldName,
    String? idEqualTo,
    String? roleFieldName,
    String? roleEqualTo,
  }) {
    //? adding middlewares here
    if (jwtSecured) {
      pipeline
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkJwtInHeaders,
          )
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkJwtForUserId,
          );
    }

    //?

    _cascade = _cascade.add(pipeline);
    return this;
  }

  ServerService addRouter(
    Router router, {
    bool jwtSecured = false,
    String? idFieldName,
    String? idEqualTo,
    String? roleFieldName,
    String? roleEqualTo,
  }) {
    //? adding middlewares here
    if (jwtSecured) {
      router
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkJwtInHeaders,
            signature: 'checkJwtInHeaders',
          )
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkJwtForUserId,
            signature: 'checkJwtForUserId',
          );
    }
    Pipeline pipeline = Pipeline().addRouter(router);

    //?

    _cascade = _cascade.add(pipeline);
    return this;
  }

  Cascade get cascade {
    return _cascade;
  }

  AuthServerSettings get authServerSettings {
    if (_authServerSettings == null) {
      throw NoAuthServerSettingsException();
    }
    return _authServerSettings!;
  }

  void _addAuthEndpoints() {
    if (_authServerSettings == null) return;
    String loginPath = authServerSettings.authEndpoints.login;
    String registerPath = authServerSettings.authEndpoints.register;
    String getVerificationEmail =
        authServerSettings.authEndpoints.getVerificationEmail;
    // String jwtLoginPath = authEndpoints.jwtLogin;

    // adding auth endpoints pipeline
    var authRouter = Router()
      ..post(
        loginPath,
        authServerSettings.authServerHandlers.login,
      )
      ..post(
        registerPath,
        authServerSettings.authServerHandlers.register,
      )
      ..post(
        getVerificationEmail,
        authServerSettings.authServerHandlers.getVerificationEmail,
      );

    addRouter(authRouter);
  }
}
