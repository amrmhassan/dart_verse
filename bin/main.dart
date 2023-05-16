// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'package:dart_verse/features/db_manager/data/datasource/memory_db.dart';
import 'package:dart_verse/features/db_manager/presentation/db_ref.dart';
import 'package:dart_verse/features/db_providers/impl/memory_db/memory_db_provider.dart';
import 'package:dart_verse/features/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';
import 'package:dart_verse/settings/db_settings/repo/conn_link.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'constants.dart';

void main(List<String> arguments) async {
  MongoDbConnLink connLink = atlasConnLink;
  MongoDBProvider mongoDBProvider = MongoDBProvider(connLink);
  MemoryDBProvider memoryDBProvider = MemoryDBProvider({});
  DBSettings dbSettings = DBSettings(
    mongoDBProvider: mongoDBProvider,
    memoryDBProvider: memoryDBProvider,
  );
  App app = App(dbSettings: dbSettings);
  await app.run();

  var coll = app.mongoDbController.collection('collection');
  print(await coll.firstDocument());
}
//? before applying the new data manager in the app
//? just find a way to handle querying with the mongodb 
//? and find a way to make use of the whole mongo_dart lib or the querying in database source
//?
//?
//?
//? you can make a tree of the data sources and classes you will need