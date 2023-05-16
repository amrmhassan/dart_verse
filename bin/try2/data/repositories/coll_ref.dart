import 'package:uuid/uuid.dart';

import '../../domain/repositories/db_entity.dart';
import '../../presentation/controllers/collection_controller.dart';
import '../datasource/database_source.dart';
import 'doc_ref.dart';
import 'path_entity.dart';

class CollRef implements DbEntity {
  final String name;
  final DocRef? parentDoc;
  final DatabaseSource databaseSource;
  late CollectionController _controller;

  CollRef(this.name, this.parentDoc, this.databaseSource) {
    _controller = CollectionController(this, databaseSource);
  }

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
}
