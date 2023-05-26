import 'dart:async';
import 'dart:io';

import 'package:dart_verse/settings/app/app.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

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
  final List<FutureOr<Response> Function(Request)> pileLines = [];

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
    var handler = cascade.handler;
    var server = await shelf_io.serve(
      handler,
      ip,
      port,
    );
    String ipString = server.address.address == InternetAddress.anyIPv4.address
        ? '127.0.0.1'
        : server.address.address;
    print('server listening on http://$ipString:${server.port}');
    return server;
  }

  ServerService addPipeline(
    FutureOr<Response> Function(Request) handler, {
    bool jwtSecured = false,
    String? idFieldName,
    String? idEqualTo,
    String? roleFieldName,
    String? roleEqualTo,
  }) {
    var securedPipeline = Pipeline();
    //? adding middlewares here
    if (jwtSecured) {
      securedPipeline = securedPipeline.addMiddleware(
        authServerSettings.authServerMiddlewares.checkJwtInHeaders,
      );
      securedPipeline = securedPipeline.addMiddleware(
        authServerSettings.authServerMiddlewares.checkJwtValid,
      );

      securedPipeline = securedPipeline.addMiddleware(
        authServerSettings.authServerMiddlewares.checkJwtForUserId,
      );
    }

    //?

    var finalHandler = securedPipeline.addHandler(handler);

    pileLines.add(finalHandler);
    _cascade = _cascade.add(finalHandler);
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
        // ..post(jwtLoginPath, (Request request) {})
        ;
    var authPipeline = Pipeline().addHandler(authRouter);
    // _cascade.add(authPipeline);
    addPipeline(authPipeline);
  }
}
