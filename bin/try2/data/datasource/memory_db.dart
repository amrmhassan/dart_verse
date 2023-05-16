import 'package:dart_verse/serverless/features/db_manager/constants/reserved_keys.dart';
import 'package:uuid/uuid.dart';

import '../../validation/naming_restrictions.dart';
import 'database_source.dart';

Map<String, List<Map<String, dynamic>>> memoryDb = {};

class MemoryDB implements DatabaseSource {
  @override
  Future<Map<String, dynamic>> insertDoc(
    String collId, {
    required Map<String, dynamic> doc,
  }) {
    // first check if the collection exist
    if (memoryDb[collId] == null) {
      memoryDb[collId] = [];
    }
    // checking for reserved collection keyword

    // create the doc id
    String docId = doc[DBRKeys.id] ?? Uuid().v4();
    // validating the doc
    DocValidation docValidation = DocValidation(docId, doc);
    doc = docValidation.validate();
    // here just save the new doc
    memoryDb[collId]!.add(doc);
    return Future.value(doc);
  }
}
