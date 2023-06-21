import 'dart:async';
import 'dart:io';

import 'package:dart_verse/settings/storage_settings/models/storage_bucket_model.dart';
import 'package:dart_verse/settings/storage_settings/repo/bucket_controller_repo.dart';
import 'package:path/path.dart';

import '../../../errors/models/storage_errors.dart';

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

class DefaultBucketController implements BucketControllerRepo {
  Directory _bucketDir() {
    Directory directory = Directory(storageBucket.folderPath);
    if (!directory.existsSync()) {
      throw BucketNotCreatedException(' from DefaultBucketController');
    }
    return directory;
  }

  @override
  void createBucket() {
    validateBucketInfo();

    // validating bucket folder path
    Directory directory = Directory(storageBucket.folderPath);
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

  @override
  Future<int> getBucketSize() {
    Directory dir = _bucketDir();
    int size = 0;
    Completer<int> completer = Completer<int>();
    var sub = dir.list(recursive: true).listen((event) async {
      var fileStats = await event.stat();
      if (fileStats.type == FileSystemEntityType.file) {
        size += fileStats.size;
      }
    });

    sub.onDone(() async {
      completer.complete(size);
      await sub.cancel();
    });
    return completer.future;
  }

  @override
  StorageBucket storageBucket;

  DefaultBucketController(this.storageBucket);

  @override
  void validateBucketInfo() {
    // validating bucket name
    if (storageBucket.name.length > 50) {
      throw StorageBucketNameException('exceeded 50 letters');
    }
    if (!_valid(storageBucket.name)) {
      throw StorageBucketNameException();
    }
    String baseName = basename(storageBucket.folderPath);
    if (baseName == '..' || baseName == '.') {
      throw StorageBucketFolderPathException();
    }
  }

  @override
  Future<void> deleteBucket() {
    Directory dir = _bucketDir();
    return dir.delete(recursive: true);
  }
}
