// you can apply acm permissions with sql db local file in the bucket itself
// instead of making your own custom one

import 'dart:io';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/features/auth_db_provider/impl/mongo_db_auth_provider/mongo_db_auth_provider.dart';
import 'package:dart_verse/features/email_verification/impl/default_email_verification_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/db_manager/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse/services/db_manager/db_service.dart';
import 'package:dart_verse/services/storage_service/storage_service.dart';
import 'package:dart_verse/services/web_server/server_service.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';
import 'package:dart_verse/settings/email_settings/email_settings.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_server_settings.dart';
import 'package:dart_verse/settings/server_settings/server_settings.dart';
import 'package:dart_verse/settings/storage_settings/storage_settings.dart';
import 'package:dart_verse/settings/user_data_settings/user_data_settings.dart';

import 'constants.dart';
import 'shelf_usage_example.dart';

//! create tests for db and for auth services and for user data service

void main(List<String> arguments) async {
  MongoDBProvider mongoDBProvider = MongoDBProvider(localConnLink);

  DBSettings dbSettings = DBSettings(mongoDBProvider: mongoDBProvider);
  UserDataSettings userDataSettings = UserDataSettings();
  AuthSettings authSettings = AuthSettings(
    jwtSecretKey: SecretKey('jwtSecretKey'),
    allowedAppsIds: ['amrhassan'],
  );
  ServerSettings serverSettings = ServerSettings(InternetAddress.anyIPv4, 3000);
  EmailSettings emailSettings = EmailSettings(testSmtpServer);
  StorageSettings storageSettings = StorageSettings();
  App app = App(
    dbSettings: dbSettings,
    authSettings: authSettings,
    userDataSettings: userDataSettings,
    serverSettings: serverSettings,
    emailSettings: emailSettings,
    storageSettings: storageSettings,
    backendHost: 'http://localhost:3000',
  );

  DbService dbService = DbService(app);
  AuthService authService = AuthService(
    MongoDbAuthProvider(app, dbService),
  );
  await dbService.connectToDb();
  // UserDataService userDataService = UserDataService(authService);
  ServerService serverService = ServerService(
    app,
    authServerSettings: DefaultAuthServerSettings(
      authService,
      cEmailVerificationProvider: DefaultEmailVerificationProvider(
        authService: authService,
        allowNewVerificationEmailAfter: Duration(minutes: 1),
        verifyLinkExpiresAfter: Duration(minutes: 5),
      ),
    ),
  );

  StorageService(app, serverService);
  await serverService.runServer();
}

// //? visit this google oauth playground https://developers.google.com/oauthplayground to get more info about how to access google services for a google account
// //? and this link for google apis assess and manage https://developers.google.com/apis-explorer
