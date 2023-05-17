// this app is the starting point of the server
// it will require settings for auth, database, realtime database, etc...
import 'package:dart_verse/features/db_manager/data/repositories/mongo_ref/coll_ref_mongo.dart';
import 'package:dart_verse/settings/defaults/default_app_settings.dart';
import 'package:dart_verse/features/app_database/controllers/db_connect.dart';
import 'package:dart_verse/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';
import 'package:dart_verse/settings/user_data_settings/user_data_settings.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../features/db_manager/data/repositories/db_controllers/memory_db_controller.dart';
import '../../features/db_manager/data/repositories/db_controllers/mongo_db_controller.dart';
import '../../features/db_manager/data/repositories/memory_ref/coll_ref_memory.dart';

//! i should keep track of collections and sub collections names in a string file or something

class App {
  final AuthSettings? _authSettings;
  final DBSettings? _dbSettings;
  final UserDataSettings _userDataSettings;

  App({
    AuthSettings? authSettings,
    DBSettings? dbSettings,
    UserDataSettings? userDataSettings,
  })  : _authSettings = authSettings,
        _dbSettings = dbSettings,
        _userDataSettings =
            userDataSettings ?? DefaultSettings.userDataSettings;

  //? the app starting point
  Future<App> run({
    bool connectToDb = true,
  }) async {
    if (connectToDb) {
      await _connectToDb();
    }

    return this;
  }

  //# mongo DB stuff
  Db? _db;

  Future<void> _connectToDb() async {
    if (_dbSettings == null) {
      throw Exception('please provide DBSettings if you wanna use db');
    }
    DbConnect dbConnect = DbConnect(this);
    await dbConnect.connectAllProvidedDBs();
    // Db db = await dbConnect.connect();
    // _db = db;
  }

  void setMongoDb(Db db) {
    _db = db;
    _setMongoController(MongoDbController(db));
  }

  Db get getDB {
    if (_db == null) {
      throw Exception('please provide DBSettings if you wanna use db');
    }
    return _db!;
  }

  //# getting db controllers
  MongoDbController? _mongoDbController;
  MongoDbController get mongoDbController {
    if (_mongoDbController == null) {
      throw Exception('no mongo db provider, please add one to db settings');
    }
    return _mongoDbController!;
  }

  MemoryDbController? _memoryDbController;
  MemoryDbController get memoryDbController {
    if (_memoryDbController == null) {
      throw Exception('no memory db provider, please add one to db settings');
    }
    return _memoryDbController!;
  }

  //# settings db controllers
  void _setMongoController(MongoDbController controller) {
    _mongoDbController = controller;
  }

  /// you don't need to play with method
  void setMemoryController(MemoryDbController controller, DbConnect source) {
    _memoryDbController = controller;
  }

//# getting difference settings instances
  AuthSettings get authSettings {
    if (_authSettings == null) {
      throw Exception('please provider authSettings to the app');
    }
    return _authSettings!;
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
