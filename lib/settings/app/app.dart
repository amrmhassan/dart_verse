// this app is the starting point of the server
// it will require settings for auth, database, realtime database, etc...
import 'package:dart_verse/errors/models/app_exceptions.dart';
import 'package:dart_verse/errors/models/user_data_errors.dart';
import 'package:dart_verse/features/app_database/controllers/db_connect.dart';
import 'package:dart_verse/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';
import 'package:dart_verse/settings/user_data_settings/user_data_settings.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../features/db_manager/data/repositories/db_controllers/memory_db_controller.dart';
import '../../features/db_manager/data/repositories/db_controllers/mongo_db_controller.dart';

//! i should keep track of collections and sub collections names in a string file or something

class App {
  final AuthSettings? _authSettings;
  final DBSettings? _dbSettings;
  final UserDataSettings? _userDataSettings;

  App({
    AuthSettings? authSettings,
    DBSettings? dbSettings,
    UserDataSettings? userDataSettings,
  })  : _authSettings = authSettings,
        _dbSettings = dbSettings,
        _userDataSettings = userDataSettings;

  //? the app starting point
  Future<App> run({
    bool connectToDb = true,
  }) async {
    if (connectToDb) {
      await _connectToDb();
    }

    return this;
  }

  //#  Connect DBs
  Future<void> _connectToDb() async {
    if (_dbSettings == null) {
      throw NoDbSettingsExceptions();
    }
    DbConnect dbConnect = DbConnect(this);
    await dbConnect.connectAllProvidedDBs(
      setMemoryController: _setMemoryController,
      setMongoDb: _setMongoDb,
    );
  }

  //# setting DBs after connecting
  void _setMongoDb(Db db) {
    dbSettings.mongoDBProvider!.setDb(db);
    _setMongoController(MongoDbController(db));
  }

  //# getting Dbs references
  Db get getMongoDB {
    if (dbSettings.mongoDBProvider == null) {
      throw NoMongoDbProviderExceptions();
    }
    return dbSettings.mongoDBProvider!.db;
  }

  Map<String, List<Map<String, dynamic>>> get getMemoryDb {
    if (dbSettings.memoryDBProvider == null) {
      throw NoMemoryDbProviderExceptions();
    }
    return dbSettings.memoryDBProvider!.memoryDb;
  }

  //# getting db controllers
  MongoDbController? _mongoDbController;
  MongoDbController get mongoDbController {
    if (_mongoDbController == null) {
      throw NoMongoDbProviderExceptions();
    }
    return _mongoDbController!;
  }

  MemoryDbController? _memoryDbController;
  MemoryDbController get memoryDbController {
    if (_memoryDbController == null) {
      throw NoMemoryDbProviderExceptions();
    }
    return _memoryDbController!;
  }

  //# settings db controllers
  void _setMongoController(MongoDbController controller) {
    _mongoDbController = controller;
  }

  /// you don't need to play with method
  void _setMemoryController(MemoryDbController controller) {
    _memoryDbController = controller;
  }

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
}
