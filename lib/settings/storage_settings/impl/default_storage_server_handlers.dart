import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_verse/constants/header_fields.dart';
import 'package:dart_verse/errors/models/storage_errors.dart';
import 'package:dart_verse/services/storage_buckets/acm_permissions/constants/default_permissions.dart';
import 'package:dart_verse/services/storage_buckets/acm_permissions/models/acm_permission.dart';
import 'package:dart_verse/services/storage_buckets/models/storage_bucket_model.dart';
import 'package:dart_verse/settings/storage_settings/repo/storage_server_handlers.dart';
import 'package:dart_verse/settings/storage_settings/storage_settings.dart';
import 'package:dart_webcore/dart_webcore/server/impl/request_holder.dart';
import 'package:dart_webcore/dart_webcore/server/impl/response_holder.dart';
import 'package:dart_webcore/dart_webcore/server/repo/passed_http_entity.dart';

import '../../../errors/models/server_errors.dart';
import '../../../errors/serverless_exception.dart';
import '../../server_settings/utils/send_response.dart';

class DefaultStorageServerHandlers implements StorageServerHandlers {
  DefaultStorageServerHandlers({
    required this.storageSettings,
  });
  @override
  StorageSettings storageSettings;

  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future Function() method,
  ) async {
    try {
      return await method();
    } on ServerException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on StorageException catch (e) {
      return SendResponse.sendAuthErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } on ServerLessException catch (e) {
      return SendResponse.sendOtherExceptionErrorToUser(
        response,
        e.message,
        e.code,
        errorCode: e.errorCode,
      );
    } catch (e) {
      return SendResponse.sendUnknownError(response, null);
    }
  }

  @override
  FutureOr<PassedHttpEntity> delete(RequestHolder request,
      ResponseHolder response, Map<String, dynamic> pathArgs) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  FutureOr<PassedHttpEntity> download(RequestHolder request,
      ResponseHolder response, Map<String, dynamic> pathArgs) {
    // TODO: implement download
    throw UnimplementedError();
  }

// headers
// bucketName: String
// allowed: List<Map<String, dynamic>>
// private: bool

  @override
  FutureOr<PassedHttpEntity> upload(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(request, response, pathArgs, () async {
      // the user will be my frontend package
      // here the user should send the bucket name he wants to save data to
      // if the bucket name is null or not sent then the user will upload or deal with the default bucket
      // if the user user sent bucket not found an error will be returned to the user
      String? bucketName = request.headers.value(HeaderFields.bucketName);
      StorageBucket? bucket = storageSettings.getBucket(bucketName);
      if (bucket == null) {
        throw NoBucketException(bucketName);
      }

      // then i want to save the uploaded file
      // but now i have a problem
      // the problem is about permissions
      // for the permissions get the permissions from the headers or just let it to be a public file
      List<ACMPermission> allowed;
      try {
        allowed = _parseAllowed(request.headers);
      } catch (e) {
        throw BadStorageBodyException(
            'allowed must be of type List<Map<String, dynamic>> [{"name":permission_name, "allowed":[list of allowed users or groups ids]}]');
      }

      // the allowed problem was solved
      // but now i need a way to get the path of the file i want to save like
      String ref = request.headers.value(HeaderFields.ref) ?? '/';
      StorageBucket refBucket = ref == '/' ? bucket : bucket.ref(ref);
      bool private =
          request.headers.value(HeaderFields.private) == 'true' ? true : false;

      var file = await request.receiveFile(refBucket.folderPath);
      return SendResponse.sendDataToUser(response, file.path);
    });
  }
}

List<ACMPermission> _parseAllowed(HttpHeaders headers) {
  String? allowedString = headers.value(HeaderFields.allowed);
  if (allowedString == null) return defaultAllAllowedAcmPermissions;
  List<dynamic> allowed = json.decode(allowedString);
  var res = allowed.map((e) => ACMPermission.fromJson(e)).toList();
  return res;

  /*
  allowed should be on the format
  {
    'write':[users ids],
    'read':[users ids],
    'delete':[users ids],
    'editPermissions':[users ids],
  }
  */
}
