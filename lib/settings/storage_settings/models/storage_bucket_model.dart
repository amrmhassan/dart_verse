import 'dart:io';

import 'package:dart_verse/errors/models/storage_errors.dart';
import 'package:path/path.dart';

String get defaultBucketsContainer => 'Buckets';

class StorageBucket {
  /// this name is it's id
  /// must only contain numbers and letters and not exceed 50 letters
  final String name;

  /// if empty this will create an empty folder in the root path of the project with the name of the storage bucket name
  /// just try not to keep it null
  late String _folderPath;

  StorageBucket(
    this.name, {
    String? folderPath,
  }) {
    _folderPath = folderPath ?? './$defaultBucketsContainer/$name';
    // validating bucket name
    if (name.length > 50) {
      throw StorageBucketNameException('exceeded 50 letters');
    }
    if (!_valid(name)) {
      throw StorageBucketNameException();
    }
    String baseName = basename(_folderPath);
    if (baseName == '..' || baseName == '.') {
      throw StorageBucketFolderPathException();
    }

    // validating bucket folder path
    Directory directory = Directory(_folderPath);
    if (!directory.existsSync()) {
      try {
        directory.createSync(recursive: true);
      } catch (e) {
        throw StorageBucketFolderPathException(
            'can\'t create the bucket folder');
      }
    }
    // check if the storage bucket is created or not
    if (!directory.existsSync()) {
      throw StorageBucketFolderPathException('bucket folder wasn\'t created');
    }
  }

  String get folderPath => _folderPath;
}

bool _valid(String name) {
  var letters = name.split('');
  for (var letter in letters) {
    if (!_validChars.contains(letter)) {
      return false;
    }
  }
  return true;
}

String _validChars = 'abcdefghijklmnopqratuvwxyz0123456789';
