// this app is the starting point of the server
// it will require settings for auth, database, realtime database, etc...
import 'package:dart_verse/serverless/settings/defaults/default_app_settings.dart';
import 'package:dart_verse/serverless/features/database/controllers/db_connect.dart';
import 'package:dart_verse/serverless/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/serverless/settings/db_settings/db_settings.dart';
import 'package:dart_verse/serverless/settings/user_data_settings/user_data_settings.dart';
import 'package:mongo_dart/mongo_dart.dart';

class App {
  final AuthSettings _authSettings;
  final DBSettings? _dbSettings;
  final UserDataSettings _userDataSettings;
  Db? _db;

  App({
    required AuthSettings authSettings,
    DBSettings? dbSettings,
    UserDataSettings? userDataSettings,
  })  : _authSettings = authSettings,
        _dbSettings = dbSettings,
        _userDataSettings =
            userDataSettings ?? DefaultSettings.userDataSettings;

  Future<App> run() async {
    await _connectToDb();

    return this;
  }

  Future<void> _connectToDb() async {
    if (_dbSettings == null) {
      throw Exception('please provide DBSettings if you wanna use db');
    }
    DbConnect dbConnect = DbConnect(_dbSettings!.connLink);
    Db db = await dbConnect.connect();
    _db = db;
  }

  Db get getDB {
    if (_db == null) {
      throw Exception('please provide DBSettings if you wanna use db');
    }
    return _db!;
  }

  AuthSettings get authSettings {
    return _authSettings;
  }

  UserDataSettings get userDataSettings {
    return _userDataSettings;
  }

  DBSettings get dbSettings {
    if (_dbSettings == null) {
      throw Exception('please provide DBSettings if you wanna use db');
    }
    return _dbSettings!;
  }
}
