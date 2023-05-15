import 'dart:async';

import 'package:dart_verse/serverless/features/db_manager/constants/reserved_keys.dart';
import 'package:dart_verse/serverless/features/db_manager/repo/doc_controller.dart';

import '../../db_repo.dart';
import '../../models/doc_ref.dart';

class MemoryDocController implements DocController {
  DocumentRef dbEntity;
  MemoryDocController(this.dbEntity);

  @override
  DocumentRef set(Map<String, dynamic> doc) {
    var documents = db[dbEntity.collRef.name];

    if (documents == null) {
      documents = [];
      db[dbEntity.collRef.name] = documents;
    } else {
      Map<String, dynamic>? existingDoc;
      try {
        existingDoc = documents.firstWhere(
          (doc) => doc[DBRKeys.id] == dbEntity.id,
        );
      } catch (e) {
        existingDoc = null;
      }

      if (existingDoc != null) {
        documents.remove(existingDoc);
      }
    }

    doc[DBRKeys.id] = dbEntity.id;
    documents.add(doc);
    return dbEntity;
  }

  @override
  FutureOr<Map<String, dynamic>> deleteById(String id) {
    // TODO: implement deleteById
    throw UnimplementedError();
  }

  @override
  FutureOr<Map<String, dynamic>?> getData(String id) {
    // TODO: implement getData
    throw UnimplementedError();
  }

  @override
  FutureOr<Map<String, dynamic>> update(Map<String, dynamic> doc) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
