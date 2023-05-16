import 'package:dart_verse/features/db_manager/data/datasource/custom_db_collection.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../domain/repositories/db_entity.dart';
import 'doc_ref.dart';
import 'path_entity.dart';

String _getCollId(String name, DocRefRepo? parentDoc) {
  if (parentDoc == null) {
    return name;
  } else {
    return '$name|${parentDoc.id}|${parentDoc.parentColl.name}';
  }
}

PathEntity _getCollPath(DbEntity entity, String name, DocRefRepo? parentDoc) {
  if (parentDoc == null) {
    return PathEntity(
      name: name,
      entity: entity,
      parentPath: null,
    );
  } else {
    return PathEntity(
      name: name,
      entity: entity,
      parentPath: parentDoc.path,
    );
  }
}

abstract class CollRefRepo {
  final String name;
  String get id;
  final DocRefRepo? parentDoc;
  PathEntity get path;

  const CollRefRepo(this.name, this.parentDoc);

  DocRefRepo doc([String? id]);
}

class CollRefMongo extends CustomDbCollection implements DbEntity, CollRefRepo {
  @override
  final String name;
  @override
  final DocRefMongo? parentDoc;
  final Db _db;

  CollRefMongo(this.name, this.parentDoc, this._db)
      : super(_db, _getCollId(name, parentDoc));

  @override
  String get id => _getCollId(name, parentDoc);

  @override
  PathEntity get path => _getCollPath(this, name, parentDoc);

  @override
  DocRefMongo doc([String? id]) {
    //! apply doc id restriction
    String docId = id ?? ObjectId().toHexString();
    return DocRefMongo(docId, this, _db);
  }
}

class CollRefMemory implements CollRefRepo, DbEntity {
  @override
  final String name;
  @override
  final DocRefMemory? parentDoc;

  CollRefMemory(this.name, this.parentDoc);

  @override
  DocRefMemory doc([String? id]) {
    //! apply doc id restriction
    String docId = id ?? ObjectId().toHexString();
    return DocRefMemory(docId, this);
  }

  @override
  String get id => _getCollId(name, parentDoc);

  @override
  PathEntity get path => _getCollPath(this, name, parentDoc);
}
