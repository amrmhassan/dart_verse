import 'package:dart_verse/settings/storage_settings/models/storage_bucket_model.dart';

abstract class BucketControllerRepo {
  late StorageBucket storageBucket;
  // create bucket
  void createBucket();
  // get bucket size
  Future<int> getBucketSize();
  // validate bucket info
  /// returns exception if not info not valid like name or bucket path
  void validateBucketInfo();
  Future<void> deleteBucket();
}
