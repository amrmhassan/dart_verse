import 'dart:async';
import 'dart:io';

import 'package:dart_verse/settings/app/app.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../../errors/models/server_errors.dart';

class ServerService {
  final App _app;
  ServerService(this._app);

  final Cascade _cascade = Cascade();
  final List<FutureOr<Response> Function(Request)> pileLines = [];

  Future<HttpServer> runServer() async {
    InternetAddress ip = _app.serverSettings.ip;
    int port = _app.serverSettings.port;
    _addAuthEndpoints();
    var server = await shelf_io.serve(
      router.handler,
      ip,
      port,
    );
    print('server listening on ${server.address.address}:${server.port}');
    return server;
  }

  ServerService addPipeline(FutureOr<Response> Function(Request) handler) {
    pileLines.add(handler);
    _cascade.add(handler);
    return this;
  }

  Cascade get router {
    if (pileLines.isEmpty) {
      throw NoRouterSetException();
    }
    return _cascade;
  }

  void _addAuthEndpoints() {
    if (_app.serverSettings.nullableAuthServerSettings != null) return;
    String loginPath =
        _app.serverSettings.authServerSettings.authEndpoints.login;
    String registerPath =
        _app.serverSettings.authServerSettings.authEndpoints.register;
    // String jwtLoginPath = _app.serverSettings.authEndpoints.jwtLogin;

    // adding auth endpoints pipeline
    var authRouter = Router()
          ..post(
            loginPath,
            _app.serverSettings.authServerSettings.authServerHandlers.login,
          )
          ..post(
            registerPath,
            _app.serverSettings.authServerSettings.authServerHandlers.register,
          )
        // ..post(jwtLoginPath, (Request request) {})
        ;
    var authPipeline = Pipeline().addHandler(authRouter);
    addPipeline(authPipeline);
  }
}
