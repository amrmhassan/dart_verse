import 'package:mongo_dart/mongo_dart.dart';

import 'collection.dart';
import 'document.dart';

Map<String, List<Map<String, dynamic>>> db = {};
String reservedKey = '_collections';

abstract class DbController {}

class CollectionController implements DbController {
  CollectionRef collection;
  CollectionController(this.collection);

  DocumentRef insertOne(Map<String, dynamic> doc) {
    if (collection.docRef != null) {
      // this means that it is a sub collection and you should get it's id first
      String subCollId =
          insertSubCollection(collection.name, collection.docRef!);
      var newCollRef = CollectionRef(subCollId, null);
      return CollectionController(newCollRef).insertOne(doc);
    }
    // checking for the reserved key for collections if exist just throw an error
    if (doc[reservedKey] != null) {
      throw Exception(
          'the $reservedKey is reserved for the DartVerse framework, please use another key');
    }
    // adding the children collections of the document to it's list
    //! but now how to know the children collections of the document
    doc[reservedKey] = [];
    // adding the id for the document
    if (doc['_id'] == null) {
      doc['_id'] = Uuid().v4();
    }

    // actual insertion to db
    if (db[collection.name] == null) {
      db[collection.name] = [];
    }
    var coll = db[collection.name]!;
    coll.add(doc);
    return DocumentRef(doc['_id'], collection);
  }

  String insertSubCollection(String subCollName, DocumentRef documentRef) {
    String parentCollName = documentRef.collRef.name;
    String docId = documentRef.id;
    late String subCollId;
    // check if the document
    var docMap =
        db[parentCollName]!.firstWhere((element) => element['_id'] == docId);
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
    return subCollId;
  }
}

class DocController implements DbController {
  DocumentRef dbEntity;
  DocController(this.dbEntity);
  DocumentRef set(Map<String, dynamic> doc) {
    // check if the doc exists or not
    if (db[dbEntity.collRef.name] == null) {
      db[dbEntity.collRef.name] = [];
    } else {
      // checking if the exist or not
      var docs =
          db[dbEntity.collRef.name]!.where((doc) => doc['_id'] == dbEntity.id);
      if (docs.isEmpty) {
        // create that doc
        doc['_id'] = dbEntity.id;
        db[dbEntity.collRef.name]!.add(doc);
      } else {
        var savedDoc = docs.first;
        for (var element in doc.entries) {
          // get the object
          savedDoc[element.key] = element.value;
        }
        // then reinsert the doc
        int index = db[dbEntity.collRef.name]!
            .indexWhere((element) => element['_id'] == savedDoc['_id']);
        db[dbEntity.collRef.name]![index] = savedDoc;
      }
    }
    return dbEntity;
  }
}
