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

  //? doc data
  Map<String, dynamic>? _data;

  void setLocalData(DatabaseSource source, Map<String, dynamic> data) {
    if (source.hashCode != databaseSource.hashCode) {
      throw Exception('you can\'t edit the doc data by yourself');
    }
    _data = {};
    data.forEach((key, value) {
      _data![key] = value;
    });
    _data = data;
  }

  Map<String, dynamic>? get data => _data;

  //# here is the querying code
  FutureOr<Map<String, dynamic>?> getData() async {
    if (_data == null) {
      var data = (await databaseSource.getDocData(this))!;
      _data = data;
      setLocalData(databaseSource, data);
      return data;
    } else {
      return _data;
    }
  }
}
