// ignore_for_file: unused_field

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
    //! here will be some checks for added buckets to check if there is any duplicate bucket like same name or same folderPath
    throw UnimplementedError();
  }
}
