abstract class ServerLessException implements Exception {
  late String message;

  @override
  String toString() {
    return message;
  }
}
