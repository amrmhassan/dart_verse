import 'package:dart_verse/settings/storage_settings/models/storage_bucket_model.dart';

void main(List<String> args) {
  // StorageBucket amr = StorageBucket(
  //   'amr',
  //   creatorId: 'amr',
  //   maxAllowedSize: 1000,
  // );

  // bool res = amr.permissionsController.isUserAllowed('read', 'esraa');
  // print(res);
  // res = amr.permissionsController.isUserAllowed('write', 'esraa');
  // print(res);
  // amr.permissionsController.allowAllToPermission('write');
  StorageBucket? fetched = StorageBucket.fromPath('./Buckets/amr');
  print(fetched);
}
