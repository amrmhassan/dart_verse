// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'package:dart_verse/features/db_providers/impl/memory_db/memory_db_provider.dart';
import 'package:dart_verse/features/db_providers/impl/mongo_db/mongo_db_provider.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/db_settings/db_settings.dart';

import 'constants.dart';

// next step is to create errors types and distribute them over the project
// create separate files for each class you created (DbControllers in App), (DocRefMemory, CollRefMemory) etc...
// delete unused class or file, to keep yourself concentrated on what is important
//! draw a map or use Miro program to draw the work flow for the app and what comes and what goes

void main(List<String> arguments) async {
  MongoDBProvider mongoDBProvider = MongoDBProvider(localConnLink);
  MemoryDBProvider memoryDBProvider = MemoryDBProvider({});
  DBSettings dbSettings = DBSettings(
    mongoDBProvider: mongoDBProvider,
    memoryDBProvider: memoryDBProvider,
  );
  App app = App(dbSettings: dbSettings);

  await app.run();
  app.userDataSettings;

  // var coll = app.memoryDbController.collection('users');
  // coll.insertDoc({'name': 'Amr Hassan', '_id': 'userId'});
  // coll.insertDoc({'name': 'Amr Hassan'});

  // print(coll.getAllDocuments().map((e) => e.getData()).toList());
  // print(coll.getDocRefById('userId')!.getData());
}
