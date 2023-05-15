import 'package:dart_verse/serverless/features/db_manager/constants/reserved_keys.dart';
import 'package:dart_verse/serverless/features/db_manager/repo/doc_controller.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'ref.dart';
import '../repo/verse_db.dart';
import 'doc_ref.dart';

class CollectionRef implements DbRefEntity {
  final String name;
  final DocumentRef? docRef;

  const CollectionRef(this.name, this.docRef);
  Future<String> id(DocController controller) async {
    if (docRef == null) {
      return name;
    } else {
      // Get the ID of the collection mapping from the parent document
      var parentDoc = await controller.getData(docRef!.id);
      if (parentDoc != null && parentDoc[DBRKeys.collections] is List) {
        var collectionMappings = parentDoc[DBRKeys.collections] as List;
        var mapping = collectionMappings.firstWhere(
          (element) => element['name'] == name,
          orElse: () => null,
        );
        if (mapping != null && mapping['id'] is String) {
          return mapping['id'];
        }
      }
      throw Exception('Collection mapping not found in the parent document.');
    }
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
}
