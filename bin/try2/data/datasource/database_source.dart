abstract class DatabaseSource {
  //? here create all methods that will be used for documents and collections
  Future<Map<String, dynamic>> insertDoc(
    String collId, {
    required Map<String, dynamic> doc,
  });
}
