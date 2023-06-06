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
  final List<Pipeline> pileLines = [];

  Future<HttpServer> runServer() async {
    InternetAddress ip = _app.serverSettings.ip;
    int port = _app.serverSettings.port;
    _addAuthEndpoints();
    //!
    // var testRouter = Router()
    //   ..get('/test', (Request request) {
    //     return Response.ok('hello');
    //   });
    // var pipeline = Pipeline().addHandler(testRouter);
    // var testCascade = _cascade.add(pipeline);
    //!
    var handler = cascade;
    ServerHolder serverHolder = ServerHolder(handler);
    var server = await serverHolder.bind(InternetAddress.anyIPv4, port);
    String ipString = server.address.address == InternetAddress.anyIPv4.address
        ? '127.0.0.1'
        : server.address.address;
    print('server listening on http://$ipString:${server.port}');
    return server;
  }

  ServerService addPipeline(
    RequestProcessor handler, {
    bool jwtSecured = false,
    String? idFieldName,
    String? idEqualTo,
    String? roleFieldName,
    String? roleEqualTo,
  }) {
    var securedPipeline = Pipeline();
    //? adding middlewares here
    if (jwtSecured) {
      securedPipeline = securedPipeline.addRawProcessor(
        authServerSettings.authServerMiddlewares.checkJwtInHeaders,
      );

      securedPipeline = securedPipeline.addRawProcessor(
        authServerSettings.authServerMiddlewares.checkJwtForUserId,
      );
    }

    //?

    var finalHandler = securedPipeline.addRawProcessor(handler);

    pileLines.add(finalHandler);
    _cascade.add(finalHandler);
    return this;
  }

  Cascade get cascade {
    if (pileLines.isEmpty) {
      throw NoRouterSetException();
    }
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

    // _cascade.add(authPipeline);
    addPipeline(authRouter);
  }
}
