import 'collection.dart';
import 'db_controller.dart';
import 'db_ref.dart';

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

  DocumentRef set(Map<String, dynamic> doc) => _docController.set(doc);
}
