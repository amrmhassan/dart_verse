import 'dart:async';

import '../repositories/coll_ref.dart';
import '../repositories/doc_ref.dart';

abstract class DatabaseSource {
  //? here create all methods that will be used for documents and collections
  FutureOr<DocRef> insertDoc(
    CollRef docRef, {
    required Map<String, dynamic> doc,
  });

  FutureOr<DocRef?> getDocRefById(
    CollRef collRef, {
    required String docId,
  });

  FutureOr<Map<String, dynamic>?> getDocData(DocRef docRef);
}
