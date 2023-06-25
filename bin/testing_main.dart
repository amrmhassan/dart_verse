import 'dart:io';

import 'package:dart_webcore/dart_webcore.dart';

void main(List<String> args) {
  Handler handler =
      Handler('/upload', HttpMethods.post, (request, response, pathArgs) async {
    return response.write('hello world');
  });
  ServerHolder serverHolder = ServerHolder(handler);
  serverHolder.bind(InternetAddress.anyIPv4, 3000);
}
