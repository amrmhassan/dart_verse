// this app is the starting point of the server
// it will require settings for auth, database, realtime database, etc...
import 'package:dart_verse/errors/models/app_exceptions.dart';
import 'package:dart_verse/errors/models/user_data_errors.dart';
import 'package:dart_verse/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';
import 'package:dart_verse/settings/server_settings/server_settings.dart';
import 'package:dart_verse/settings/user_data_settings/user_data_settings.dart';

import '../../errors/models/server_errors.dart';

//! i should keep track of collections and sub collections names in a string file or something

class App {
  final AuthSettings? _authSettings;
  final DBSettings? _dbSettings;
  final UserDataSettings? _userDataSettings;
  final ServerSettings? _serverSettings;

  App({
    AuthSettings? authSettings,
    DBSettings? dbSettings,
    UserDataSettings? userDataSettings,
    ServerSettings? serverSettings,
  })  : _authSettings = authSettings,
        _dbSettings = dbSettings,
        _userDataSettings = userDataSettings,
        _serverSettings = serverSettings;

  //? the app starting point
  // Future<App> run({
  //   bool connectToDb = true,
  // }) async {
  //   if (connectToDb) {
  //     await _connectToDb();
  //   }

  //   return this;
  // }

  //# getting difference settings instances
  AuthSettings get authSettings {
    if (_authSettings == null) {
      throw NoAuthSettings();
    }
    return _authSettings!;
  }

  UserDataSettings get userDataSettings {
    if (_userDataSettings == null) {
      throw NoUserDataSettingsException();
    }
    return _userDataSettings!;
  }

  DBSettings get dbSettings {
    if (_dbSettings == null) {
      throw NoDbSettingsExceptions();
    }
    return _dbSettings!;
  }

  ServerSettings get serverSettings {
    if (_serverSettings == null) {
      throw NoServerSettingsExceptions();
    }
    return _serverSettings!;
  }
}
