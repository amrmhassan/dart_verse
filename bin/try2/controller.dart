import 'coll_ref.dart';

class CollectionController {
  //? here do the same as the document controller and control the collection
  final CollRef collRef;
  final DatabaseSource databaseSource;
  const CollectionController(this.collRef, this.databaseSource);
  void insertOne() {}
}

class DocumentController {
  final DocRef docRef;
  final DatabaseSource databaseSource;
  const DocumentController(this.docRef, this.databaseSource);
  //? here use the database source document methods to control the document

  void add() {}
}

abstract class DatabaseSource {
  //? here create all methods that will be used for documents and collections
}

class MemoryDataBase implements DatabaseSource {}

class MongoDataBase implements DatabaseSource {}
