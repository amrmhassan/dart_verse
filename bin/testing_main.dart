import 'package:dart_verse/layers/services/storage_service/utils/buckets_store.dart';

void main(List<String> args) async {
  // Handler handler =
  //     Handler('/upload', HttpMethods.post, (request, response, pathArgs) async {
  //   return response.write('hello world');
  // });
  // ServerHolder serverHolder = ServerHolder(handler);
  // serverHolder.bind(InternetAddress.anyIPv4, 3000);
  // print('start');
  // await StorageOperations.rename('./files/copies/newName.mp3', 'loool');
  // print('end');

  // box.put('name', 'Amr');

  await BucketsStore().init();
  BucketsStore.bucketsBox.put('test', 'test');
  var bucketPath = BucketsStore.getBucketPath('test');
  print(bucketPath);
}
