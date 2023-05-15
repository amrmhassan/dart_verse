import '../models/collection_ref.dart';

class DbRef {
  CollectionRef collection(String name) {
    return CollectionRef(name, null);
  }
}

class DbRefEntity {}
