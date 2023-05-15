import 'package:mongo_dart/mongo_dart.dart';

import 'db_controller.dart';
import 'db_ref.dart';
import 'document.dart';

class CollectionRef implements DbRefEntity {
  final String name;
  final DocumentRef? docRef;
  late CollectionController _dbController;
  CollectionRef(this.name, this.docRef) {
    _dbController = CollectionController(this);
  }

  DocumentRef doc([String? id]) {
    String randomId = id ?? Uuid().v4();
    return DocumentRef(randomId, this);
  }

  Ref get ref {
    return Ref(
      name,
      docRef?.ref,
      this,
    );
  }

  DocumentRef insertOne(Map<String, dynamic> doc) =>
      _dbController.insertOne(doc);
}
