// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_verse/serverless/settings/app.dart';
import 'package:dart_verse/serverless/features/auth/auth_service.dart';
import 'package:dart_verse/serverless/settings/auth_settings/auth_settings.dart';
import 'package:dart_verse/serverless/settings/db_settings/db_settings.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'constants.dart';

String storedHash1 =
    'ZTljNjAzZGEtNDEwYi00ZDQzLWFiOWQtYzI0ZmUwOTEzNDZl:ML9n9tlKKRWQehLI79ajpqcwCMPDsccjK4KA0Nkj0Po=';
String storedHash2 =
    'NTRhZjAyODYtZjA5MS00YjhiLTljZmUtOWNiMWFjZTNmOTAz:EyNscqECPDDpwGlaNIC0YxgGVkdKzA2rq4/42V3c3Yc=';
String storedHash3 =
    'YjkyNDE1MzQtMjM0My00Yzc1LWIwNDEtZWQ3OTljZTNhY2Rm:RkgMfC87pieulo/AkUoHmbJIlDLn8A373Nwsl+lkfbc=';

void main(List<String> arguments) async {
  DateTime before = DateTime.now();
  String password = 'aaaaa11111';
  // String hash = getPasswordHash(password);
  print(checkPassword(password, storedHash1));
  print(checkPassword(password, storedHash2));
  print(checkPassword(password, storedHash3));
  DateTime after = DateTime.now();
  // print(hash);
  print('${after.difference(before).inMicroseconds / 1000}ms');
}

String getPasswordHash(String password) {
  List<int> saltBytes = utf8.encode(Uuid().v4());
  final saltedPasswordBytes = utf8.encode(password) + saltBytes;
  final hashedBytes = sha256.convert(saltedPasswordBytes).bytes;
  final encodedSalt = base64.encode(saltBytes);
  final encodedHash = base64.encode(hashedBytes);
  String finalResult = '$encodedSalt:$encodedHash';
  return finalResult;
}

bool checkPassword(String password, String storedHash) {
  // Extract the salt and hashed password from the stored hash
  List<String> parts = storedHash.split(':');
  String encodedSalt = parts[0];
  String encodedHash = parts[1];

  // Decode the salt and hashed password from base64
  List<int> saltBytes = base64.decode(encodedSalt);
  List<int> hashedBytes = base64.decode(encodedHash);

  // Concatenate the salt with the provided password
  List<int> saltedPasswordBytes = utf8.encode(password) + saltBytes;

  // Hash the salted password using SHA-256
  List<int> computedHash = sha256.convert(saltedPasswordBytes).bytes;

  // Compare the computed hash with the stored hash
  return computedHash.length == hashedBytes.length &&
      computedHash
          .every((byte) => byte == hashedBytes[computedHash.indexOf(byte)]);
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
