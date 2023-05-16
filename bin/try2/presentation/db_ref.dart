import '../data/datasource/database_source.dart';
import '../data/repositories/coll_ref.dart';

class DbRef {
  final DatabaseSource databaseSource;
  const DbRef(this.databaseSource);

  CollRef collection(String name) {
    return CollRef(name, null, databaseSource);
  }
}
