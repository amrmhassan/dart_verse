// ignore_for_file: unused_field

import 'package:dart_verse/errors/models/storage_errors.dart';
import 'package:dart_verse/settings/storage_settings/models/storage_bucket_model.dart';

import '../../settings/app/app.dart';

class StorageService {
  final App _app;

  final List<StorageBucket> buckets;
  StorageService(
    this._app, {
    this.buckets = const [],
  }) {
    _checkDuplicateBuckets();
  }

  void addBucket(StorageBucket bucket) {
    buckets.add(bucket);
    _checkDuplicateBuckets();
  }

  void _checkDuplicateBuckets() {
    List<String> names = [];
    List<String> paths = [];
    for (var bucket in buckets) {
      if (paths.contains(bucket.folderPath)) {
        throw DuplicateBucketPathException(bucket.folderPath);
      }
      names.add(bucket.name);
      paths.add(bucket.folderPath);
    }
  }
}
