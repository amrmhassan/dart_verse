// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'package:auth_server/features/app/app.dart';

void main(List<String> arguments) async {
  await app.init();
}
