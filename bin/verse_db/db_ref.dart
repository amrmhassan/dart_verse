import 'collection.dart';

class VerseDb {
  static DbRef get instance => DbRef();
}

class DbRef {
  CollectionRef collection(String name) {
    return CollectionRef(name, null);
  }
}

class DbRefEntity {}

class Ref {
  final Ref? parent;
  final String ref;
  final DbRefEntity dbEntity;

  const Ref(
    this.ref,
    this.parent,
    this.dbEntity,
  );

  @override
  String toString() {
    if (parent == null) {
      return ref;
    }
    return '${parent!.toString()}/$ref';
  }
}


// collections can be stored directly into the database
// documents can be stored directly into the collection but not the reverse
// so each document will have a value called _collections and it will a list of collections ids which will reference to actual collections in the database itself
//?
// so i need to differentiate between 2 things, the DbEntityRef and the DbEntity itself which will be stored into the database

//? all calls to or from db will be done from the db controller 