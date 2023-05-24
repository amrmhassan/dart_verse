import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() {
  var authHandlers = Router()
    ..get('/login', (Request request) {
      return Response.ok('logging');
    });
  var userDataHandlers = Router()
    ..get('/user/<id>', (Request req, String id) {
      return Response.ok('getting user id $id');
    });

  var authPipeLine = Pipeline().addMiddleware(
    (innerHandler) {
      return (Request req) {
        print(req.url.path);
        return Response.ok('hello');
        // return innerHandler(req);
      };
    },
  ).addHandler(authHandlers);

  var userPipeLine =
      Pipeline().addMiddleware(logRequests()).addHandler(userDataHandlers);
  var cascade = Cascade().add(authPipeLine).add(userPipeLine);
  var port = 8080;
  shelf_io.serve(cascade.handler, InternetAddress.anyIPv4, port).then((server) {
    print('Server listening on port $port');
  });
}
