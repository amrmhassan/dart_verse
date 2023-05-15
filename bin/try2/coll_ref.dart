import 'package:mongo_dart/mongo_dart.dart';

//? max collection name is 255 letters so i have 250 letters to play with so 250/3 is 80 letters
//? doc ids and coll naming restrictions
//# 1] no spaces
//# 2] max size is 80 bytes
//# 3] can't contains   /\. "$*<>:|?   characters

class DbRef {
  static CollRef collection(String name) {
    return CollRef(name, null);
  }
}

abstract class DbEntity {}

class CollRef implements DbEntity {
  final String name;
  final DocRef? parentDoc;

  const CollRef(this.name, this.parentDoc);

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
    return DocRef(docId, this);
  }
}

class DocRef implements DbEntity {
  final String id;
  final CollRef parentColl;

  const DocRef(this.id, this.parentColl);

  PathEntity get path {
    return PathEntity(
      name: id,
      entity: this,
      parentPath: parentColl.path,
    );
  }

  CollRef collection(String name) {
    return CollRef(name, this);
  }
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
