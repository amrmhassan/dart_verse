// ignore_for_file: overridden_fields

import 'package:dart_verse/services/web_server/repo/error_codes.dart';

import '../serverless_exception.dart';

class StorageException extends ServerLessException {
  @override
  String message;
  @override
  String code;

  @override
  int errorCode;
  StorageException(
    this.message,
    this.code, {
    this.errorCode = 500,
  }) : super(
          code,
          errorCode: errorCode,
        );
}

//? storage errors
class StorageBucketNameException extends StorageException {
  StorageBucketNameException([String? msg])
      : super(
          'storage bucket name invalid, must only contain numbers and letters and not exceed 50 letters: ${msg ?? ''}',
          ErrorCodes.storageBucketNameInvalid,
        );
}

class StorageBucketFolderPathException extends StorageException {
  StorageBucketFolderPathException([String? msg])
      : super(
          'please enter a valid folder path: ${msg ?? ''}',
          ErrorCodes.storageBucketPathInvalid,
        );
}

class BucketNotCreatedException extends StorageException {
  BucketNotCreatedException([String? msg])
      : super(
          'storage bucket wasn\'t created! please create it first: ${msg ?? ''}',
          ErrorCodes.storageBucketPathInvalid,
        );
}

class DuplicateBucketPathException extends StorageException {
  DuplicateBucketPathException([String? msg])
      : super(
          'duplicate bucket path: ${msg ?? ''}',
          ErrorCodes.storageBucketPathInvalid,
        );
}
