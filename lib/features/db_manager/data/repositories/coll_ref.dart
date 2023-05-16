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

class CollRef extends CustomDbCollection implements DbEntity {
  final String name;
  final DocRef? parentDoc;
  final Db db;

  CollRef(this.name, this.parentDoc, this.db)
      : super(db, _getCollId(name, parentDoc));

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
    String docId = id ?? Uuid().v4();
    return DocRef(docId, this, db);
  }

  // //# here are the code for querying databases
  // FutureOr<DocRef> insertDoc(
  //   Map<String, dynamic> doc,
  // ) {
  //   return databaseSource.insertDoc(this, doc: doc);
  // }

  // FutureOr<DocRef?> getDocById(
  //   String docId,
  // ) {
  //   return databaseSource.getDocRefById(this, docId: docId);
  // }

  // FutureOr<Iterable<DocRef>> getAllDocuments() {
  //   return databaseSource.getAllDocuments(this);
  // }
}
