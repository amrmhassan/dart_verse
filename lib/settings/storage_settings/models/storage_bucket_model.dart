import 'package:dart_verse/settings/storage_settings/impl/default_bucket_controller.dart';
import 'package:dart_verse/settings/storage_settings/repo/bucket_controller_repo.dart';
import 'package:dart_verse/utils/string_utils.dart';

String get defaultBucketsContainer => 'Buckets';

class StorageBucket {
  /// this name is it's id, should be unique
  /// must only contain numbers and letters and not exceed 50 letters
  final String name;

  /// this is the maximum allowed bucket size in bytes
  /// if null this means that the bucket size can be infinity
  final int? maxAllowedSize;

  /// if empty this will create an empty folder in the root path of the project with the name of the storage bucket name
  /// just try not to keep it null
  late String _parentPath;

  /// this is the controller for bucket operations like creating validating and much more
  /// if null, this bucket controller will be assigned to a default bucket controller
  late BucketControllerRepo _controller;

  final String creatorId;

  StorageBucket(
    this.name, {
    String? parentFolderPath,
    this.maxAllowedSize,
    BucketControllerRepo? controller,
    required this.creatorId,
  }) {
    _controller = controller ?? DefaultBucketController(this);
    _parentPath = parentFolderPath ?? defaultBucketsContainer;
    _parentPath = _parentPath.replaceAll('//', '/');
    _parentPath = _parentPath.replaceAll('\\', '/');
    _parentPath = _parentPath.strip('/');
    _controller.createBucket();
  }

  String get folderPath => '$_parentPath/$name';
  String get parentPath => _parentPath;
  BucketControllerRepo get controller => _controller;

  StorageBucket child(String name) {
    return StorageBucket(
      name,
      parentFolderPath: folderPath,
      creatorId: creatorId,
    );
  }

  StorageBucket ref(String path) {
    List<String> iterations = path.strip('/').split('/');
    String localFolderPath =
        iterations.sublist(0, iterations.length - 1).join('/');
    var res = StorageBucket(
      iterations.last,
      parentFolderPath: '$folderPath/$localFolderPath',
      creatorId: creatorId,
    );
    return res;
  }

//! every storage bucket must contain .acm file which will contain it's permissions
//! write
//! read
//! delete
//!
//@ the creatorId will be stored in the bucket itself as a file containing the id of the creator
// in this method parent i will know about a storage bucket by it's .acm file
  StorageBucket? parent() {
    throw UnimplementedError();
  }
}
