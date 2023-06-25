import 'package:dart_verse/services/storage_manager/utils/isolates.dart';

void main(List<String> args) async {
  // Handler handler =
  //     Handler('/upload', HttpMethods.post, (request, response, pathArgs) async {
  //   return response.write('hello world');
  // });
  // ServerHolder serverHolder = ServerHolder(handler);
  // serverHolder.bind(InternetAddress.anyIPv4, 3000);
  print('start');
  await StorageOperations.rename('./files/copies/newName.mp3', 'loool');
  print('end');
}
