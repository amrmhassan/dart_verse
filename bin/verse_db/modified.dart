import 'package:mongo_dart/mongo_dart.dart';

Map<String, List<Map<String, dynamic>>> db = {};

abstract class VerseDb {
  static DbRef get instance => DbRef();
}

class DbRef {
  CollectionRef collection(String name) {
    return CollectionRef(name, null);
  }
}

class DbRefEntity {}

String reservedKey = '_collections';

abstract class DbController {}

class CollectionRef implements DbRefEntity {
  final String _name;
  final DocumentRef? docRef;
  late CollectionController _dbController;

  CollectionRef(this._name, this.docRef) {
    _dbController = CollectionController(this);
  }
  String get name {
    if (docRef == null) {
      return _name;
    } else {
      // Get the ID of the collection mapping from the parent document
      var parentDoc = docRef!.getData();
      if (parentDoc != null && parentDoc[reservedKey] is List) {
        var collectionMappings = parentDoc[reservedKey] as List;
        var mapping = collectionMappings.firstWhere(
          (element) => element['name'] == _name,
          orElse: () => null,
        );
        if (mapping != null && mapping['id'] is String) {
          return mapping['id'];
        }
      }
      throw Exception('Collection mapping not found in the parent document.');
    }
  }

  DocumentRef doc([String? id]) {
    String randomId = id ?? Uuid().v4();
    return DocumentRef(randomId, this);
  }

  Ref get ref {
    return Ref(
      _name,
      docRef?.ref,
      this,
    );
  }

  DocumentRef insertOne(Map<String, dynamic> doc) {
    return _dbController.insertOne(doc);
  }

  List<Map<String, dynamic>> getAllDocuments() {
    if (db[name] == null) {
      return [];
    }
    return List<Map<String, dynamic>>.from(db[name]!);
  }

  Map<String, dynamic>? getDocumentById(String id) {
    var documents = getAllDocuments();
    try {
      return documents.firstWhere((doc) => doc['_id'] == id);
    } catch (e) {
      return null;
    }
  }

  void updateDocumentById(String id, Map<String, dynamic> updatedDoc) {
    var documents = getAllDocuments();
    var index = documents.indexWhere((doc) => doc['_id'] == id);
    if (index != -1) {
      documents[index] = {...documents[index], ...updatedDoc};
    }
  }

  void deleteDocumentById(String id) {
    var documents = getAllDocuments();
    documents.removeWhere((doc) => doc['_id'] == id);
  }
}

class CollectionController implements DbController {
  CollectionRef collection;
  CollectionController(this.collection);

  DocumentRef insertOne(Map<String, dynamic> doc) {
    if (collection.docRef != null) {
      String subCollId =
          insertSubCollection(collection._name, collection.docRef!)._name;
      var newCollRef = CollectionRef(subCollId, null);
      return CollectionController(newCollRef).insertOne(doc);
    }

    // Checking for the reserved key for collections, if it exists, throw an error
    if (doc.containsKey(reservedKey)) {
      throw Exception(
          'The $reservedKey is reserved for the DartVerse framework. Please use another key.');
    }

    // Adding the children collections of the document to its list
    doc[reservedKey] = [];

    // Adding the id for the document
    if (doc['_id'] == null) {
      doc['_id'] = Uuid().v4();
    }

    // Actual insertion to db
    db.putIfAbsent(collection._name, () => []);
    db[collection._name]!.add(doc);

    return DocumentRef(doc['_id'], collection);
  }

  CollectionRef insertSubCollection(
      String subCollName, DocumentRef documentRef) {
    String parentCollName = documentRef.collRef._name;
    String docId = documentRef.id;
    String subCollId;

    List<Map<String, dynamic>>? parentColl = db[parentCollName];

    if (parentColl == null) {
      // Parent collection doesn't exist, create it
      parentColl = [];
      db[parentCollName] = parentColl;
    }

    var docMap = parentColl.firstWhere(
      (element) => element['_id'] == docId,
      orElse: () {
        // Document doesn't exist, create it
        var newDoc = {
          '_id': Uuid().v4(),
          reservedKey: [],
        };
        parentColl!.add(newDoc);
        return newDoc;
      },
    );

    var docSubCollections = (docMap[reservedKey] as List);
    var savedCollections =
        docSubCollections.where((element) => element['name'] == subCollName);

    if (savedCollections.isEmpty) {
      subCollId = Uuid().v4();
      docSubCollections.add({
        'id': subCollId,
        'name': subCollName,
      });
    } else {
      subCollId = savedCollections.first['id'];
    }

    return CollectionRef(subCollId, documentRef);
  }

  List<Map<String, dynamic>> getAllDocuments() {
    if (db[collection._name] == null) {
      return [];
    }
    return List<Map<String, dynamic>>.from(db[collection._name]!);
  }

  Map<String, dynamic>? getDocumentById(String id) {
    var documents = getAllDocuments();
    try {
      return documents.firstWhere((doc) => doc['_id'] == id);
    } catch (e) {
      return null;
    }
  }

  void updateDocumentById(String id, Map<String, dynamic> updatedDoc) {
    var documents = getAllDocuments();
    var index = documents.indexWhere((doc) => doc['_id'] == id);
    if (index != -1) {
      documents[index] = {...documents[index], ...updatedDoc};
    }
  }

  void deleteDocumentById(String id) {
    var documents = getAllDocuments();
    documents.removeWhere((doc) => doc['_id'] == id);
  }
}

class DocController implements DbController {
  DocumentRef dbEntity;
  DocController(this.dbEntity);

  DocumentRef set(Map<String, dynamic> doc) {
    var documents = db[dbEntity.collRef._name];

    if (documents == null) {
      documents = [];
      db[dbEntity.collRef._name] = documents;
    } else {
      Map<String, dynamic>? existingDoc;
      try {
        existingDoc = documents.firstWhere(
          (doc) => doc['_id'] == dbEntity.id,
        );
      } catch (e) {
        existingDoc = null;
      }

      if (existingDoc != null) {
        documents.remove(existingDoc);
      }
    }

    doc['_id'] = dbEntity.id;
    documents.add(doc);
    return dbEntity;
  }
}

class Ref {
  final Ref? parent;
  final String ref;
  final DbRefEntity dbEntity;

  const Ref(
    this.ref,
    this.parent,
    this.dbEntity,
  );

  @override
  String toString() {
    if (parent == null) {
      return ref;
    }
    return '${parent!.toString()}/$ref';
  }
}

class DocumentRef implements DbRefEntity {
  final String id;
  final CollectionRef collRef;
  late DocController _docController;

  DocumentRef(this.id, this.collRef) {
    _docController = DocController(this);
  }

  CollectionRef collection(String name) {
    return CollectionRef(name, this);
  }

  Ref get ref {
    return Ref(
      id,
      collRef.ref,
      this,
    );
  }

  DocumentRef set(Map<String, dynamic> doc) {
    return _docController.set(doc);
  }

  void update(Map<String, dynamic> updatedDoc) {
    collRef.updateDocumentById(id, updatedDoc);
  }

  void delete() {
    collRef.deleteDocumentById(id);
  }

  Map<String, dynamic>? getData() {
    return collRef.getDocumentById(id);
  }
}
