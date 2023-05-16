import 'dart:async';

import '../../domain/repositories/db_entity.dart';
import '../datasource/database_source.dart';
import 'coll_ref.dart';
import 'path_entity.dart';

class DocRef implements DbEntity {
  final String id;
  final CollRef parentColl;
  final DatabaseSource databaseSource;

  DocRef(this.id, this.parentColl, this.databaseSource);

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

  //# here is the querying code
  FutureOr<Map<String, dynamic>?> getData() async {
    var data = (await databaseSource.getDocData(this))!;
    return data;
  }
}
