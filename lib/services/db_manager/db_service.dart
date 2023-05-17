import 'package:dart_verse/errors/models/database_errors.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../errors/models/app_exceptions.dart';
import '../../features/app_database/controllers/db_connect.dart';
import 'data/repositories/db_controllers/memory_db_controller.dart';
import 'data/repositories/db_controllers/mongo_db_controller.dart';

class DbService {
  final App _app;
  DbService(App app) : _app = app;
  bool _dbConnected = false;

  MongoDbController get mongoDbController {
    if (!_dbConnected) {
      throw DbNotConnectedException();
    }
    if (_app.dbSettings.mongoDBProvider == null) {
      throw NoMongoDbProviderExceptions();
    }
    if (_mongoDbController == null) {
      throw NoMongoDbProviderExceptions();
    }
    return _mongoDbController!;
  }

  MemoryDbController get memoryDbController {
    if (!_dbConnected) {
      throw DbNotConnectedException();
    }
    if (_app.dbSettings.memoryDBProvider == null) {
      throw NoMemoryDbProviderExceptions();
    }

    if (_memoryDbController == null) {
      throw NoMemoryDbProviderExceptions();
    }

    return _memoryDbController!;
  }

  //#  Connect DBs
  Future<void> connectToDb() async {
    DbConnect dbConnect = DbConnect(_app);
    await dbConnect.connectAllProvidedDBs(
      setMemoryController: _setMemoryController,
      setMongoDb: _setMongoDb,
    );
    _dbConnected = true;
  }

  //# setting DBs after connecting
  void _setMongoDb(Db db) {
    _app.dbSettings.mongoDBProvider!.setDb(db);
    _setMongoController(MongoDbController(db));
  }

  //# getting Dbs references
  Db get getMongoDB {
    if (_app.dbSettings.mongoDBProvider == null) {
      throw NoMongoDbProviderExceptions();
    }
    return _app.dbSettings.mongoDBProvider!.db;
  }

  Map<String, List<Map<String, dynamic>>> get getMemoryDb {
    if (_app.dbSettings.memoryDBProvider == null) {
      throw NoMemoryDbProviderExceptions();
    }
    return _app.dbSettings.memoryDBProvider!.memoryDb;
  }

  //# getting db controllers
  MongoDbController? _mongoDbController;

  MemoryDbController? _memoryDbController;

  //# settings db controllers
  void _setMongoController(MongoDbController controller) {
    _mongoDbController = controller;
  }

  /// you don't need to play with method
  void _setMemoryController(MemoryDbController controller) {
    _memoryDbController = controller;
  }
}
