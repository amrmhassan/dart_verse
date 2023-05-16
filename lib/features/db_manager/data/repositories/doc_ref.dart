import 'package:dart_verse/features/db_manager/data/datasource/custom_db_document.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../domain/repositories/db_entity.dart';
import 'coll_ref.dart';
import 'path_entity.dart';

class DocRef extends CustomDbDocument implements DbEntity {
  final String id;
  final CollRef parentColl;
  final Db db;

  DocRef(this.id, this.parentColl, this.db)
      : super(
          db,
          id,
          parentColl,
        );

  PathEntity get path {
    return PathEntity(
      name: id,
      entity: this,
      parentPath: parentColl.path,
    );
  }

  CollRef collection(String name) {
    return CollRef(name, this, db);
  }

  //? doc data
  // Map<String, dynamic>? _data;

  // void setLocalData(DatabaseSource source, Map<String, dynamic> data) {
  //   if (source.hashCode != databaseSource.hashCode) {
  //     throw Exception('you can\'t edit the doc data by yourself');
  //   }
  //   _data = {};
  //   data.forEach((key, value) {
  //     _data![key] = value;
  //   });
  //   _data = data;
  // }

  // Map<String, dynamic>? get data => _data;

  // //# here is the querying code
  // FutureOr<Map<String, dynamic>?> getData() async {
  //   var data = (await databaseSource.getDocData(this))!;
  //   _data = data;
  //   setLocalData(databaseSource, data);
  //   return data;
  // }

  // FutureOr<DocRef> set(
  //   Map<String, dynamic> newDoc,
  // ) {
  //   return databaseSource.set(this, newDoc: newDoc);
  // }

  // FutureOr<DocRef> update(
  //   Map<String, dynamic> newDoc,
  // ) {
  //   return databaseSource.update(this, newDoc: newDoc);
  // }
}
