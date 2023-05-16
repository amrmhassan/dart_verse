import 'package:dart_verse/features/db_manager/data/repositories/coll_ref.dart';
import 'package:dart_verse/features/db_manager/data/repositories/doc_ref.dart';
import 'package:uuid/uuid.dart';

import '../../constants/reserved_keys.dart';
import '../../validation/naming_restrictions.dart';

class MemoryDbCollection {
  final Map<String, List<Map<String, dynamic>>> _memoryDb;
  const MemoryDbCollection(this._memoryDb);

  //? here i will add the code for controlling a collection from the memory db
  DocRefMemory insertDoc(
    CollRefMemory collRef, {
    required Map<String, dynamic> doc,
  }) {
    String collId = collRef.id;
    // first check if the collection exist
    // here i need to check if the collection has a parent doc or not
    //
    if (_memoryDb[collId] == null) {
      _memoryDb[collId] = [];
    }

    // create the doc id
    String docId = doc[DBRKeys.id] ?? Uuid().v4();
    // validating the doc
    DocValidation docValidation = DocValidation(docId, doc);
    doc = docValidation.validate();
    // here just save the new doc
    _memoryDb[collId]!.add(doc);
    return DocRefMemory(docId, collRef, _memoryDb);
  }

  DocRefMemory? getDocRefById(
    CollRefMemory collRef, {
    required String docId,
  }) {
    String collId = collRef.id;
    if (_memoryDb[collId] == null) return null;
    Map<String, dynamic>? doc = _memoryDb[collId]!.cast().firstWhere(
          (doc) => doc[DBRKeys.id] == docId,
          orElse: () => null,
        );
    if (doc == null) {
      return null;
    } else {
      String docId = doc[DBRKeys.id];
      return DocRefMemory(docId, collRef, _memoryDb);
    }
  }

  Iterable<DocRefMemory> getAllDocuments(CollRefMemory collRef) {
    String collId = collRef.id;
    // check if coll exists or not
    if (_memoryDb[collId] == null) {
      return [];
    }
    // gets actual docs
    var docs = _memoryDb[collId]!.map((e) {
      var docRef = DocRefMemory(e[DBRKeys.id], collRef, _memoryDb);
      return docRef;
    });
    return docs;
  }
}
