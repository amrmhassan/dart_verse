import 'package:dart_verse/serverless/features/db_manager/constants/reserved_keys.dart';
import 'package:dart_verse/serverless/features/db_manager/repo/collection_controller.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../db_repo.dart';
import '../../models/collection_ref.dart';
import '../../models/doc_ref.dart';

class MemoryCollectionController implements CollectionController {
  CollectionRef collection;
  MemoryCollectionController(this.collection);

  @override
  DocumentRef insertOne(Map<String, dynamic> doc) {
    if (collection.docRef != null) {
      String subCollId =
          insertSubCollection(collection.name, collection.docRef!).name;
      var newCollRef = CollectionRef(subCollId, null);
      return MemoryCollectionController(newCollRef).insertOne(doc);
    }

    // Checking for the reserved key for collections, if it exists, throw an error
    if (doc.containsKey(DBRKeys.collections)) {
      throw Exception(
          'The ${DBRKeys.collections} is reserved for the DartVerse framework. Please use another key.');
    }

    // Adding the children collections of the document to its list
    doc[DBRKeys.collections] = [];

    // Adding the id for the document
    if (doc[DBRKeys.id] == null) {
      doc[DBRKeys.id] = Uuid().v4();
    }

    // Actual insertion to db
    db.putIfAbsent(collection.name, () => []);
    db[collection.name]!.add(doc);

    return DocumentRef(doc[DBRKeys.id], collection);
  }

  @override
  CollectionRef insertSubCollection(
      String subCollName, DocumentRef documentRef) {
    String parentCollName = documentRef.collRef.name;
    String docId = documentRef.id;
    String subCollId;

    List<Map<String, dynamic>>? parentColl = db[parentCollName];

    if (parentColl == null) {
      // Parent collection doesn't exist, create it
      parentColl = [];
      db[parentCollName] = parentColl;
    }

    var docMap = parentColl.firstWhere(
      (element) => element[DBRKeys.id] == docId,
      orElse: () {
        // Document doesn't exist, create it
        var newDoc = {
          DBRKeys.id: Uuid().v4(),
          DBRKeys.collections: [],
        };
        parentColl!.add(newDoc);
        return newDoc;
      },
    );

    var docSubCollections = (docMap[DBRKeys.collections] as List);
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

  @override
  List<Map<String, dynamic>> getAllDocuments() {
    if (db[collection.name] == null) {
      return [];
    }
    return List<Map<String, dynamic>>.from(db[collection.name]!);
  }

  @override
  Map<String, dynamic>? getDocumentById(String id) {
    var documents = getAllDocuments();
    try {
      return documents.firstWhere((doc) => doc[DBRKeys.id] == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> updateDocumentById(
    String id,
    Map<String, dynamic> updatedDoc,
  ) {
    var documents = getAllDocuments();
    var index = documents.indexWhere((doc) => doc[DBRKeys.id] == id);
    if (index != -1) {
      documents[index] = {...documents[index], ...updatedDoc};
    }
    return documents[index];
  }

  @override
  Map<String, dynamic> deleteDocumentById(String id) {
    var documents = getAllDocuments();
    int index = documents.indexWhere((doc) => doc[DBRKeys.id] == id);
    return documents.removeAt(index);
  }
}
