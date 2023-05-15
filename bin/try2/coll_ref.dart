import 'package:uuid/uuid.dart';

import 'controller.dart';

//? max collection name is 255 letters so i have 250 letters to play with so 250/3 is 80 letters
//? doc ids and coll naming restrictions
//# 1] no spaces
//# 2] max size is 80 bytes
//# 3] can't contains   /\. "$*<>:|?   characters

class DbRef {
  final DatabaseSource databaseSource;
  const DbRef(this.databaseSource);

  CollRef collection(String name) {
    return CollRef(name, null, databaseSource);
  }
}

abstract class DbEntity {}

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

// this class might be used to reconstruct the ref object from the path of the entity(doc or collection)
class PathEntity {
  /// this will be the name of the collection or id of the document
  final String name;
  final DbEntity entity;
  final PathEntity? parentPath;

  const PathEntity({
    required this.name,
    required this.entity,
    required this.parentPath,
  });

  String get _path {
    if (parentPath == null) {
      return name;
    } else {
      return '${parentPath!._path}/$name';
    }
  }

  @override
  String toString() {
    return _path;
  }
}
