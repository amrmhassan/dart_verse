import 'dart:async';

import '../repositories/coll_ref.dart';
import '../repositories/doc_ref.dart';

abstract class DatabaseSource {
  //? here create all methods that will be used for documents and collections
  //# for collections
  FutureOr<DocRef> insertDoc(
    CollRef docRef, {
    required Map<String, dynamic> doc,
  });

  FutureOr<DocRef?> getDocRefById(
    CollRef collRef, {
    required String docId,
  });

  FutureOr<Iterable<DocRef>> getAllDocuments(CollRef collRef);

  //# for documents
  /// this set one will remove the old one and add the new one
  FutureOr<DocRef> set(
    DocRef docRef, {
    required Map<String, dynamic> newDoc,
  });

  /// this will just return the doc data
  FutureOr<Map<String, dynamic>?> getDocData(DocRef docRef);

  /// this will override the old values only with the new values form the newDoc
  FutureOr<DocRef> update(
    DocRef docRef, {
    required Map<String, dynamic> newDoc,
  });
}
