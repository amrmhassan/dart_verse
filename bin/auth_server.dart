// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'package:auth_server/serverless/settings/app.dart';
import 'package:auth_server/serverless/features/auth/controllers/auth_controller.dart';
import 'package:auth_server/serverless/settings/auth_settings/auth_settings.dart';
import 'package:auth_server/serverless/settings/db_settings/db_settings.dart';

import 'constants.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void main(List<String> arguments) async {
  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2OTE3Nzc1NTQsImlhdCI6MTY4NDAwMTU1NCwicGxkIjp7IlRoaXMgaXMgcGF5bG9lYSI6IiJ9fQ.xOIhcT01GMQMocT9FDEeOw2-vJgxqdnz406phRSKeUA';
  String key = 'hmacKey';

  var res = JWT.verify(token, SecretKey(key));
  print(res.payload);
}

void runApp() async {
  DBSettings dbSettings = DBSettings(connLink: cloudsConnLink);
  AuthSettings authSettings = AuthSettings(
    jwtSecretKey: env['JWTSECRETKEY'].toString(),
  );

  App app = App(
    dbSettings: dbSettings,
    authSettings: authSettings,
  );
  await app.run();
  await app.getDB.drop();
  AuthService authService = AuthService(app);
  // await authService.registerUser(email: 'amr@gmail.com', password: 'password');
  var authModel =
      await authService.loginUser(email: 'amr@gmail.com', password: 'password');
  print(authModel);
}
