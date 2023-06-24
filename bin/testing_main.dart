import 'package:dart_verse/settings/storage_settings/models/storage_bucket_model.dart';

void main(List<String> args) {
  // var amr = StorageBucket('amr', creatorId: 'amr');
  // var child = amr.child('data');
  var data = StorageBucket.fromPath('./Buckets/amr/data');
  print(data);
}
