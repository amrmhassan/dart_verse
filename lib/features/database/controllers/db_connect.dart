import 'package:dart_verse/features/database/controllers/db_connect/memory_db_connect.dart';
import 'package:dart_verse/features/database/controllers/db_connect/mongo_db_connect.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/db_settings/repo/conn_link.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DbConnect {
  final App _app;
  const DbConnect(this._app);

  Future<void> connectAllProvidedDBs() async {
    //? trying to connect to mongodb if exist
    MongoDbConnLink? mongoDbConnLink =
        _app.dbSettings.mongoDBProvider?.connLink;
    MongoDbConnect mongoDbConnect = MongoDbConnect(mongoDbConnLink);
    Db? db = await mongoDbConnect.connect();
    // setting the app _db because the app depends on it
    if (db != null) {
      // throw Exception('can\'t connect to mongo db');
      _app.setMongoDb(db);
    }

    //? trying to connect to memory db if exist
    var memoryDb = _app.dbSettings.memoryDBProvider?.memoryDb;
    MemoryDbConnect memoryDbConnect = MemoryDbConnect(memoryDb);
    await memoryDbConnect.connect();
    if (memoryDb != null) {
      _app.setMemoryController(MemoryDbController(memoryDb), this);
    }
  }
}
