import 'dart:io';

// !
// @ add the storage management, static files serving with the ability to run html, js css, files, sending messages to a socket server
// !
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/features/auth_db_provider/impl/mongo_db_auth_provider/mongo_db_auth_provider.dart';
import 'package:dart_verse/features/email_verification/impl/default_email_verification_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/db_manager/db_providers/impl/memory_db/memory_db_provider.dart';
import 'package:dart_verse/services/db_manager/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse/services/db_manager/db_service.dart';
import 'package:dart_verse/services/web_server/server_service.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';
import 'package:dart_verse/settings/email_settings/email_settings.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_server_settings.dart';
import 'package:dart_verse/settings/server_settings/server_settings.dart';
import 'package:dart_verse/settings/user_data_settings/user_data_settings.dart';
import 'package:dart_webcore/dart_webcore.dart';

import 'constants.dart';
import 'shelf_usage_example.dart';

//! create tests for db and for auth services and for user data service

void main(List<String> arguments) async {
  MongoDBProvider mongoDBProvider = MongoDBProvider(localConnLink);
  MemoryDBProvider memoryDBProvider = MemoryDBProvider({});

  DBSettings dbSettings = DBSettings(
    mongoDBProvider: mongoDBProvider,
    memoryDBProvider: memoryDBProvider,
  );
  UserDataSettings userDataSettings = UserDataSettings();
  AuthSettings authSettings = AuthSettings(
    jwtSecretKey: SecretKey('jwtSecretKey'),
    allowedAppsIds: ['amrhassan'],
  );
  ServerSettings serverSettings = ServerSettings(InternetAddress.anyIPv4, 3000);
  EmailSettings emailSettings = EmailSettings(testSmtpServer);
  App app = App(
    dbSettings: dbSettings,
    authSettings: authSettings,
    userDataSettings: userDataSettings,
    serverSettings: serverSettings,
    emailSettings: emailSettings,
  );

  DbService dbService = DbService(app);
  AuthService authService = AuthService(MongoDbAuthProvider(app, dbService));
  await dbService.connectToDb();
  // UserDataService userDataService = UserDataService(authService);
  ServerService serverService = ServerService(
    app,
    authServerSettings: DefaultAuthServerSettings(
      app,
      authService,
      cEmailVerificationProvider: DefaultEmailVerificationProvider(
        authService: authService,
        allowNewJwtAfter: Duration(minutes: 1),
        verifyLinkExpiresAfter: Duration(minutes: 5),
      ),
    ),
  );

  var userDataRouter = Router()
    ..get('/user/<id>', (request, response, pathArgs) {
      return response
          .write('user data fetched successfully with id: ${pathArgs["id"]}');
    });
  serverService.addRouter(userDataRouter, jwtSecured: true);
  await serverService.runServer();
}

// //? visit this google oauth playground https://developers.google.com/oauthplayground to get more info about how to access google services for a google account
// //? and this link for google apis assess and manage https://developers.google.com/apis-explorer
