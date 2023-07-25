import 'dart:io';

class StorageUtils {
  static bool isFile(String path) {
    return File(path).existsSync();
  }

  static bool isDir(String path) {
    return Directory(path).existsSync();
  }
}
