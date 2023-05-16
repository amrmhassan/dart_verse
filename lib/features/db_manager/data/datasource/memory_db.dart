// import 'dart:async';

// import '../../constants/reserved_keys.dart';
// import 'package:uuid/uuid.dart';

// import '../../validation/naming_restrictions.dart';
// import '../repositories/coll_ref.dart';
// import '../repositories/doc_ref.dart';
// import 'database_source.dart';

// Map<String, List<Map<String, dynamic>>> memoryDb = {};

// class MemoryDB implements DatabaseSource {
//   @override
//   DocRef insertDoc(
//     CollRef collRef, {
//     required Map<String, dynamic> doc,
//   }) {
//     String collId = collRef.id;
//     // first check if the collection exist
//     // here i need to check if the collection has a parent doc or not
//     //
//     if (memoryDb[collId] == null) {
//       memoryDb[collId] = [];
//     }

//     // create the doc id
//     String docId = doc[DBRKeys.id] ?? Uuid().v4();
//     // validating the doc
//     DocValidation docValidation = DocValidation(docId, doc);
//     doc = docValidation.validate();
//     // here just save the new doc
//     memoryDb[collId]!.add(doc);
//     return DocRef(docId, collRef);
//   }

//   @override
//   DocRef? getDocRefById(
//     CollRef collRef, {
//     required String docId,
//   }) {
//     String collId = collRef.id;
//     if (memoryDb[collId] == null) return null;
//     Map<String, dynamic>? doc = memoryDb[collId]!.cast().firstWhere(
//           (doc) => doc[DBRKeys.id] == docId,
//           orElse: () => null,
//         );
//     if (doc == null) {
//       return null;
//     } else {
//       String docId = doc[DBRKeys.id];
//       return DocRef(docId, collRef, this);
//     }
//   }

//   @override
//   FutureOr<Iterable<DocRef>> getAllDocuments(CollRef collRef) {
//     String collId = collRef.id;
//     // check if coll exists or not
//     if (memoryDb[collId] == null) {
//       return [];
//     }
//     // gets actual docs
//     var docs = memoryDb[collId]!.map((e) {
//       var docRef = DocRef(e[DBRKeys.id], collRef, this);
//       docRef.setLocalData(this, e);
//       return docRef;
//     });
//     return docs;
//   }

//   @override
//   FutureOr<DocRef> set(
//     DocRef docRef, {
//     required Map<String, dynamic> newDoc,
//   }) {
//     String collId = docRef.parentColl.id;
//     // create the doc parent collection if not exist
//     if (memoryDb[collId] == null) {
//       memoryDb[collId] = [];
//     }
//     // get the old data if not exist create one
//     int index = memoryDb[collId]!
//         .indexWhere((element) => element[DBRKeys.id] == docRef.id);

//     // insert new one if the old one doesn't exist
//     if (index == -1) {
//       return insertDoc(docRef.parentColl, doc: newDoc);
//     }
//     // or just remove the old one and set the new one
//     // the id of a doc can't be changed
//     var oldDoc = memoryDb[collId]![index];
//     String docId = oldDoc[DBRKeys.id];
//     newDoc[DBRKeys.id] = docId;
//     // get the old doc index in the collection
//     memoryDb[collId]![index] = newDoc;
//     var newDocRef = DocRef(docRef.id, docRef.parentColl, this);
//     newDocRef.setLocalData(this, newDoc);
//     return newDocRef;
//   }

//   @override
//   FutureOr<DocRef> update(
//     DocRef docRef, {
//     required Map<String, dynamic> newDoc,
//   }) {
//     String collId = docRef.parentColl.id;
//     if (memoryDb[collId] == null) {
//       memoryDb[collId] = [];
//     }
//     int index = memoryDb[collId]!
//         .indexWhere((element) => element[DBRKeys.id] == docRef.id);
//     if (index == -1) {
//       return insertDoc(docRef.parentColl, doc: newDoc);
//     }
//     var oldDoc = memoryDb[collId]![index];
//     // the id of a doc can't be changed
//     newDoc[DBRKeys.id] = oldDoc[DBRKeys.id];
//     newDoc.forEach((key, value) {
//       oldDoc[key] = value;
//     });
//     return set(docRef, newDoc: oldDoc);
//   }

//   @override
//   FutureOr<Map<String, dynamic>?> getDocData(DocRef docRef) {
//     String collId = docRef.parentColl.id;
//     if (memoryDb[collId] == null) return null;
//     Map<String, dynamic>? doc = memoryDb[collId]!.cast().firstWhere(
//           (doc) => doc[DBRKeys.id] == docRef.id,
//           orElse: () => null,
//         );
//     return doc;
//   }
// }
