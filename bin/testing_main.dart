import 'package:dart_verse/settings/storage_settings/models/storage_bucket_model.dart';

void main(List<String> args) {
  StorageBucket amr = StorageBucket(
    'amr',
    parentFolderPath: 'd:/',
    creatorId: 'amr',
  );
  StorageBucket amrImages = amr.ref('data/images');
  amrImages.child('verified');
  print(amr.folderPath);
  print(amrImages.folderPath);
}
