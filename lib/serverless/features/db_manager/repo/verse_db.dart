import '../controllers/collection_ref.dart';

abstract class VerseDb {
  static DbRef get instance => DbRef();
}

class DbRef {
  CollectionRef collection(String name) {
    return CollectionRef(name, null);
  }
}

class DbRefEntity {}

abstract class DbController {}
