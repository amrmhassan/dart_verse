import 'package:dart_verse/serverless/features/db_manager/constants/reserved_keys.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../db_repo.dart';
import '../models/ref.dart';
import '../repo/verse_db.dart';
import 'collection_controller.dart';
import 'doc_ref.dart';

class CollectionRef implements DbRefEntity {
  final String name;
  final DocumentRef? docRef;
  late CollectionController _dbController;

  CollectionRef(this.name, this.docRef) {
    _dbController = CollectionController(this);
  }
  String get id {
    if (docRef == null) {
      return name;
    } else {
      // Get the ID of the collection mapping from the parent document
      var parentDoc = docRef!.getData();
      if (parentDoc != null && parentDoc[DBRKeys.collections] is List) {
        var collectionMappings = parentDoc[DBRKeys.collections] as List;
        var mapping = collectionMappings.firstWhere(
          (element) => element['name'] == name,
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
      name,
      docRef?.ref,
      this,
    );
  }

  DocumentRef insertOne(Map<String, dynamic> doc) {
    return _dbController.insertOne(doc);
  }

  List<Map<String, dynamic>> getAllDocuments() {
    if (db[id] == null) {
      return [];
    }
    return List<Map<String, dynamic>>.from(db[id]!);
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
