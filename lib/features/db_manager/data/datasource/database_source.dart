import 'dart:async';

import '../repositories/coll_ref.dart';
import '../repositories/doc_ref.dart';

abstract class DatabaseSource {
  //? here create all methods that will be used for documents and collections
  //# for collections
  FutureOr<DocRefMongo> insertDoc(
    CollRefMongo docRef, {
    required Map<String, dynamic> doc,
  });

  FutureOr<DocRefMongo?> getDocRefById(
    CollRefMongo collRef, {
    required String docId,
  });

  FutureOr<Iterable<DocRefMongo>> getAllDocuments(CollRefMongo collRef);

  //# for documents
  /// this set one will remove the old one and add the new one
  FutureOr<DocRefMongo> set(
    DocRefMongo docRef, {
    required Map<String, dynamic> newDoc,
  });

  /// this will just return the doc data
  FutureOr<Map<String, dynamic>?> getDocData(DocRefMongo docRef);

  /// this will override the old values only with the new values form the newDoc
  FutureOr<DocRefMongo> update(
    DocRefMongo docRef, {
    required Map<String, dynamic> newDoc,
  });
}
