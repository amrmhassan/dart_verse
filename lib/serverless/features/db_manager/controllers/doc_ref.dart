import '../models/ref.dart';
import '../repo/verse_db.dart';
import 'collection_ref.dart';
import 'doc_controller.dart';

class DocumentRef implements DbRefEntity {
  final String id;
  final CollectionRef collRef;
  late DocController _docController;

  DocumentRef(this.id, this.collRef) {
    _docController = DocController(this);
  }

  CollectionRef collection(String name) {
    return CollectionRef(name, this);
  }

  Ref get ref {
    return Ref(
      id,
      collRef.ref,
      this,
    );
  }

  DocumentRef set(Map<String, dynamic> doc) {
    return _docController.set(doc);
  }

  void update(Map<String, dynamic> updatedDoc) {
    collRef.updateDocumentById(id, updatedDoc);
  }

  void delete() {
    collRef.deleteDocumentById(id);
  }

  Map<String, dynamic>? getData() {
    return collRef.getDocumentById(id);
  }
}
