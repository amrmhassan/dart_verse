import 'package:dart_verse/features/db_manager/data/datasource/custom_db_collection.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../domain/repositories/db_entity.dart';
import 'doc_ref.dart';
import 'path_entity.dart';

String _getCollId(String name, DocRef? parentDoc) {
  if (parentDoc == null) {
    return name;
  } else {
    return '$name|${parentDoc.id}|${parentDoc.parentColl.name}';
  }
}

abstract class CollRefRepo {
  final String name;
  String get id;
  final DocRefRepo? parentDoc;

  const CollRefRepo(this.name, this.parentDoc);
}

class CollRef extends CustomDbCollection implements DbEntity, CollRefRepo {
  @override
  final String name;
  @override
  final DocRef? parentDoc;
  final Db _db;

  CollRef(this.name, this.parentDoc, this._db)
      : super(_db, _getCollId(name, parentDoc));

  String get id => _getCollId(name, parentDoc);

  PathEntity get path {
    if (parentDoc == null) {
      return PathEntity(
        name: name,
        entity: this,
        parentPath: null,
      );
    } else {
      return PathEntity(
        name: name,
        entity: this,
        parentPath: parentDoc!.path,
      );
    }
  }

  DocRef doc([String? id]) {
    //! apply doc id restriction
    String docId = id ?? ObjectId().toHexString();
    return DocRef(docId, this, _db);
  }
}
