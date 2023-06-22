import 'package:dart_verse/settings/storage_settings/models/storage_bucket_model.dart';

void main(List<String> args) {
  // var images = StorageBucket.fromPath('./Buckets/amr/data/images');
  // print(images);
  // print(images?.parent());
  StorageBucket amr = StorageBucket.fromPath('/Buckets/amr')!;
  var child = amr.child('hello');
  print(amr);

  // var bucket = amr.ref('data/images');
  // print(bucket.folderPath);
}
