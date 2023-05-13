// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'package:auth_server/serverless/app/app.dart';
import 'package:auth_server/serverless/features/auth/controllers/auth_controller.dart';
import 'package:auth_server/serverless/settings/auth_settings.dart';
import 'package:auth_server/serverless/settings/db_settings/db_settings.dart';

import 'constants.dart';

void main(List<String> arguments) async {
  DBSettings dbSettings = DBSettings(connLink: cloudsConnLink);
  AuthSettings authSettings = AuthSettings();

  App app = App(
    dbSettings: dbSettings,
    authSettings: authSettings,
  );
  await app.run();
  await app.getDB.drop();
  AuthService authService = AuthService(app);
  await authService.registerUser(email: 'amr@gmail.com', password: 'password');
  var authModel =
      await authService.loginUser(email: 'amr@gmail.com', password: 'password');
  print(authModel);
}
