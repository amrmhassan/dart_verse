import '../../domain/repositories/db_entity.dart';
import '../../presentation/controllers/document_controller.dart';
import '../datasource/database_source.dart';
import 'coll_ref.dart';
import 'path_entity.dart';

class DocRef implements DbEntity {
  final String id;
  final CollRef parentColl;
  late DocumentController _controller;
  final DatabaseSource databaseSource;

  DocRef(this.id, this.parentColl, this.databaseSource) {
    _controller = DocumentController(this, databaseSource);
  }

  PathEntity get path {
    return PathEntity(
      name: id,
      entity: this,
      parentPath: parentColl.path,
    );
  }

  CollRef collection(String name) {
    return CollRef(name, this, databaseSource);
  }

  //? here just recreate all the _controller methods
  // update()
  // set()
  // delete()
  // getData()
}
