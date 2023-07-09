import 'dart:io';

import 'package:dart_verse/constants/global_constants.dart';
import 'package:hive/hive.dart';

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
  var data = box.get('name');
  print(data);
}
