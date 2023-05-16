import 'package:dart_verse/features/db_manager/data/datasource/memory_db_collection.dart';
import 'package:dart_verse/features/db_manager/data/datasource/memory_db_document.dart';
import 'package:dart_verse/features/db_manager/data/datasource/mongo_db_document.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../domain/repositories/db_entity.dart';
import 'coll_ref.dart';
import 'path_entity.dart';

PathEntity _getDocPath(String id, DbEntity entity, CollRefRepo parentColl) {
  return PathEntity(
    name: id,
    entity: entity,
    parentPath: parentColl.path,
  );
}

abstract class DocRefRepo {
  final String id;
  final CollRefRepo parentColl;
  PathEntity get path;

  const DocRefRepo(this.id, this.parentColl);

  CollRefRepo collection(String name);
}

class DocRefMongo extends MongoDbDocument implements DbEntity, DocRefRepo {
  @override
  final String id;
  @override
  final CollRefMongo parentColl;
  final Db _db;

  DocRefMongo(this.id, this.parentColl, this._db) : super(id, parentColl);

  @override
  PathEntity get path => _getDocPath(id, this, parentColl);

  @override
  CollRefMongo collection(String name) {
    return CollRefMongo(name, this, _db);
  }
}

class DocRefMemory extends MemoryDbDocument implements DocRefRepo, DbEntity {
  @override
  final String id;
  @override
  final CollRefMemory parentColl;
  final Map<String, List<Map<String, dynamic>>> _memoryDb;

  const DocRefMemory(this.id, this.parentColl, this._memoryDb)
      : super(_memoryDb, parentColl, id);

  @override
  CollRefRepo collection(String name) {
    return CollRefMemory(name, this, _memoryDb);
  }

  @override
  PathEntity get path => _getDocPath(id, this, parentColl);
}
