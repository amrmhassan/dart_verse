import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../domain/repositories/db_entity.dart';
import '../datasource/database_source.dart';
import 'doc_ref.dart';
import 'path_entity.dart';

class CollRef implements DbEntity {
  final String name;
  final DocRef? parentDoc;
  final DatabaseSource databaseSource;

  CollRef(this.name, this.parentDoc, this.databaseSource);

  String get id {
    if (parentDoc == null) {
      return name;
    } else {
      return '$name|${parentDoc!.id}|${parentDoc!.parentColl.name}';
    }
  }

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
    return DocRef(docId, this, databaseSource);
  }

  //# here are the code for querying databases
  FutureOr<DocRef> insertDoc(
    Map<String, dynamic> doc,
  ) {
    return databaseSource.insertDoc(this, doc: doc);
  }

  FutureOr<DocRef?> getDocById(
    String docId,
  ) {
    return databaseSource.getDocRefById(this, docId: docId);
  }
}
