abstract class ServerLessException implements Exception {
  late String message;
  final String code;
  ServerLessException(this.code);

  @override
  String toString() {
    return '$runtimeType: $message \ncode: $code';
  }
}
