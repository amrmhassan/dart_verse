import 'package:dart_verse/features/db_manager/data/repositories/coll_ref.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CustomDbDocument {
  final Db db;
  final String id;
  final CollRef collRef;
  const CustomDbDocument(
    this.db,
    this.id,
    this.collRef,
  );

  /// this will update certain values presented in the doc object
  Future<WriteResult> update(Map<String, dynamic> doc) async {
    var selector = where.eq('_id', id);
    var updateQuery = modify;
    doc.forEach((key, value) {
      updateQuery = updateQuery.set(key, value);
    });
    return collRef.updateOne(selector, updateQuery);
  }

  /// this will delete the document
  Future<WriteResult> delete() async {
    var selector = where.eq('_id', id);
    return collRef.deleteOne(selector);
  }

  /// this will remove the old document and add another one with the same id
  Future<WriteResult> set(Map<String, dynamic> doc) async {
    var deleteRes = await delete();
    if (deleteRes.failure || deleteRes.isFailure) {
      return deleteRes;
    }
    doc['_id'] = id;
    return collRef.insertOne(doc);
  }

  Future<Map<String, dynamic>?> getData() async {
    var selector = where.eq('_id', id);
    return collRef.findOne(selector);
  }
}
