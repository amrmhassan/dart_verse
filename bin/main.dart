import 'dart:io';

import 'package:dart_verse/features/auth_db_provider/mongo_db_auth_provider/mongo_db_auth_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/db_manager/db_providers/impl/memory_db/memory_db_provider.dart';
import 'package:dart_verse/services/db_manager/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse/services/db_manager/db_service.dart';
import 'package:dart_verse/services/web_server/server_service.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_server_settings.dart';
import 'package:dart_verse/settings/server_settings/server_settings.dart';
import 'package:dart_verse/settings/user_data_settings/user_data_settings.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import 'constants.dart';

//! just continue the server service and make it easy to be used
void testRouter() {
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

void main(List<String> arguments) async {
  MongoDBProvider mongoDBProvider = MongoDBProvider(localConnLink);
  MemoryDBProvider memoryDBProvider = MemoryDBProvider({});

  DBSettings dbSettings = DBSettings(
    mongoDBProvider: mongoDBProvider,
    memoryDBProvider: memoryDBProvider,
  );
  UserDataSettings userDataSettings = UserDataSettings();
  AuthSettings authSettings = AuthSettings(jwtSecretKey: 'jwtSecretKey');
  ServerSettings serverSettings = ServerSettings(InternetAddress.anyIPv4, 3000);
  App app = App(
    dbSettings: dbSettings,
    authSettings: authSettings,
    userDataSettings: userDataSettings,
    serverSettings: serverSettings,
  );

  DbService dbService = DbService(app);
  AuthService authService = AuthService(MongoDbAuthProvider(app, dbService));
  await dbService.connectToDb();
  // UserDataService userDataService = UserDataService(authService);
  ServerService serverService = ServerService(
    app,
    authServerSettings: DefaultAuthServerSettings(authService),
  );

  var userDataRouter = Router()
    ..get('/user/<id>', (Request request, String id) {
      return Response.ok('user data fetched successfully with id $id');
    });
  var userDataHandler = Pipeline().addHandler(userDataRouter);
  serverService.addPipeline(
    userDataHandler,
    jwtSecured: true,
  );
  await serverService.runServer();
}

//? visit this google oauth playground https://developers.google.com/oauthplayground to get more info about how to access google services for a google account
//? and this link for google apis assess and manage https://developers.google.com/apis-explorer
