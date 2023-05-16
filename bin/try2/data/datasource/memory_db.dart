import 'dart:async';

import 'package:dart_verse/serverless/features/db_manager/constants/reserved_keys.dart';
import 'package:uuid/uuid.dart';

import '../../validation/naming_restrictions.dart';
import '../repositories/coll_ref.dart';
import '../repositories/doc_ref.dart';
import 'database_source.dart';

Map<String, List<Map<String, dynamic>>> memoryDb = {};

class MemoryDB implements DatabaseSource {
  @override
  DocRef insertDoc(
    CollRef collRef, {
    required Map<String, dynamic> doc,
  }) {
    String collId = collRef.id;
    // first check if the collection exist
    // here i need to check if the collection has a parent doc or not
    //
    if (memoryDb[collId] == null) {
      memoryDb[collId] = [];
    }

    // create the doc id
    String docId = doc[DBRKeys.id] ?? Uuid().v4();
    // validating the doc
    DocValidation docValidation = DocValidation(docId, doc);
    doc = docValidation.validate();
    // here just save the new doc
    memoryDb[collId]!.add(doc);
    return DocRef(docId, collRef, this);
  }

  @override
  DocRef? getDocRefById(
    CollRef collRef, {
    required String docId,
  }) {
    String collId = collRef.id;
    if (memoryDb[collId] == null) return null;
    Map<String, dynamic>? doc = memoryDb[collId]!.cast().firstWhere(
          (doc) => doc[DBRKeys.id] == docId,
          orElse: () => null,
        );
    if (doc == null) {
      return null;
    } else {
      String docId = doc[DBRKeys.id];
      return DocRef(docId, collRef, this);
    }
  }

  @override
  FutureOr<Map<String, dynamic>?> getDocData(DocRef docRef) {
    String collId = docRef.parentColl.id;
    if (memoryDb[collId] == null) return null;
    Map<String, dynamic>? doc = memoryDb[collId]!.cast().firstWhere(
          (doc) => doc[DBRKeys.id] == docRef.id,
          orElse: () => null,
        );
    return doc;
  }
}
