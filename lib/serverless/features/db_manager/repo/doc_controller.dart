import 'dart:async';

import 'package:dart_verse/serverless/features/db_manager/models/doc_ref.dart';

abstract class DocController {
  FutureOr<DocumentRef> set(Map<String, dynamic> doc);
  FutureOr<Map<String, dynamic>> update(Map<String, dynamic> doc);
  FutureOr<Map<String, dynamic>> deleteById(String id);
  FutureOr<Map<String, dynamic>?> getData(String id);
}
