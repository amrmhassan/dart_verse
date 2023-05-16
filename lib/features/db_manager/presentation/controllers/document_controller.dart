import '../../data/datasource/database_source.dart';
import '../../data/repositories/doc_ref.dart';

class DocumentController {
  final DocRefMongo docRef;
  final DatabaseSource databaseSource;
  const DocumentController(this.docRef, this.databaseSource);
  //? here use the database source document methods to control the document

  void add() {}
}
