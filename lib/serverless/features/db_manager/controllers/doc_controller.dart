import '../db_repo.dart';
import '../repo/verse_db.dart';
import 'doc_ref.dart';

class DocController implements DbController {
  DocumentRef dbEntity;
  DocController(this.dbEntity);

  DocumentRef set(Map<String, dynamic> doc) {
    var documents = db[dbEntity.collRef.name];

    if (documents == null) {
      documents = [];
      db[dbEntity.collRef.name] = documents;
    } else {
      Map<String, dynamic>? existingDoc;
      try {
        existingDoc = documents.firstWhere(
          (doc) => doc['_id'] == dbEntity.id,
        );
      } catch (e) {
        existingDoc = null;
      }

      if (existingDoc != null) {
        documents.remove(existingDoc);
      }
    }

    doc['_id'] = dbEntity.id;
    documents.add(doc);
    return dbEntity;
  }
}
