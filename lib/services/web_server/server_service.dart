import 'dart:async';
import 'dart:io';

import 'package:dart_verse/settings/app/app.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import '../../errors/models/server_errors.dart';

class ServerService {
  final App _app;
  ServerService(this._app);

  final Cascade _cascade = Cascade();
  final List<FutureOr<Response> Function(Request)> pileLines = [];
  Future<HttpServer> runServer() async {
    InternetAddress ip = _app.serverSettings.ip;
    int port = _app.serverSettings.port;
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
}
