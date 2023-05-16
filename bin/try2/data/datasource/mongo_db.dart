import 'database_source.dart';

class MongoDB implements DatabaseSource {
  @override
  Future<Map<String, dynamic>> insertDoc(String collId,
      {required Map<String, dynamic> doc}) {
    // TODO: implement insertDoc
    throw UnimplementedError();
  }
}
