// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'package:dart_verse/features/db_providers/impl/memory_db/memory_db_provider.dart';
import 'package:dart_verse/features/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';

import 'constants.dart';

void main(List<String> arguments) async {
  MongoDBProvider mongoDBProvider = MongoDBProvider(localConnLink);
  MemoryDBProvider memoryDBProvider = MemoryDBProvider({});
  DBSettings dbSettings = DBSettings(
    mongoDBProvider: mongoDBProvider,
    memoryDBProvider: memoryDBProvider,
  );
  App app = App(dbSettings: dbSettings);
  await app.run();
  for (var i = 0; i < 30000; i++) {
    DateTime before = DateTime.now();
    var doc = app.mongoDbController.collection('users').doc();
    await doc.set({'name': 'Amr'});
    await doc.collection('hobbies').insertOne({'hobby': 'Sports'});
    DateTime after = DateTime.now();
    String time =
        (after.difference(before).inMicroseconds / 1000).toStringAsFixed(2);
    print('doc number $i with id ${doc.id} inserted in $time ms ');
  }
  print('all done');
}
//? before applying the new data manager in the app
//? just find a way to handle querying with the mongodb
//? and find a way to make use of the whole mongo_dart lib or the querying in database source
//?
//?
//?
//? you can make a tree of the data sources and classes you will need


