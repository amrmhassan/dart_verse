import 'dart:async';

import 'package:dart_verse/serverless/features/db_manager/models/collection_ref.dart';
import 'package:dart_verse/serverless/features/db_manager/models/doc_ref.dart';

abstract class CollectionController {
  FutureOr<DocumentRef> insertOne(Map<String, dynamic> doc);
  FutureOr<List<Map<String, dynamic>>> getAllDocuments();
  FutureOr<Map<String, dynamic>?> getDocumentById(String id);
  FutureOr<Map<String, dynamic>> updateDocumentById(
    String id,
    Map<String, dynamic> updatedDoc,
  );
  FutureOr<Map<String, dynamic>> deleteDocumentById(String id);
  FutureOr<CollectionRef> insertSubCollection(
    String subCollName,
    DocumentRef documentRef,
  );
}
