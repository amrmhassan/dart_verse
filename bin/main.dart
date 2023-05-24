import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

//! just continue the server service and make it easy to be used
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

//! create tests for db and for auth services and for user data service

// void main(List<String> arguments) async {
  // MongoDBProvider mongoDBProvider = MongoDBProvider(localConnLink);
  // MemoryDBProvider memoryDBProvider = MemoryDBProvider({});

  // DBSettings dbSettings = DBSettings(
  //   mongoDBProvider: mongoDBProvider,
  //   memoryDBProvider: memoryDBProvider,
  // );
  // UserDataSettings userDataSettings = UserDataSettings();
  // AuthSettings authSettings = AuthSettings(jwtSecretKey: 'jwtSecretKey');
  // App app = App(
  //   dbSettings: dbSettings,
  //   authSettings: authSettings,
  //   userDataSettings: userDataSettings,
  // );

  // DbService dbService = DbService(app);
  // await dbService.connectToDb();
  // AuthService authService = AuthService(MongoDbAuthProvider(app, dbService));
  // UserDataService userDataService = UserDataService(authService);
// }

//? visit this google oauth playground https://developers.google.com/oauthplayground to get more info about how to access google services for a google account
//? and this link for google apis assess and manage https://developers.google.com/apis-explorer