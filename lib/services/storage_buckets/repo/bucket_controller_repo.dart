import 'dart:io';

import 'package:dart_verse/services/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';

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
  Future<File> receiveFile(RequestHolder request
      // , {
      // required List<ACMPermission>? allowed,
      // }
      );
}
