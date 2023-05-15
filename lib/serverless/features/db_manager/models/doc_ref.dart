import 'ref.dart';
import '../repo/verse_db.dart';
import 'collection_ref.dart';

class DocumentRef implements DbRefEntity {
  final String id;
  final CollectionRef collRef;

  DocumentRef(this.id, this.collRef);

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
}
