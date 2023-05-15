// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'verse_db/modified.dart';

void main(List<String> arguments) async {
  var d = db;
  var collection = VerseDb.instance.collection('users');
  var doc = collection.doc('hobbies');
  var hobbyDoc = doc.collection('hobbies').insertOne({
    '_id': 'running',
    'name': 'Running Skill',
    'skills': 'Very skilled',
  });
  var userDoc = VerseDb.instance.collection('users').getAllDocuments().first;
  String userId = userDoc['_id'];
  print(d);
  var finalDoc = VerseDb.instance
      .collection('users')
      .doc(userId)
      .collection('hobbies')
      .doc(hobbyDoc.id)
      .getData();

  print(d);
}

// void runApp() async {
//   DBSettings dbSettings = DBSettings(connLink: atlasConnLink);
//   AuthSettings authSettings = AuthSettings(
//     jwtSecretKey: env['JWTSECRETKEY'].toString(),
//   );

//   App app = App(
//     dbSettings: dbSettings,
//     authSettings: authSettings,
//   );
//   await app.run();
//   AuthService authService = AuthService(app);
//   // String jwt = await authService.registerUser(
//   //     email: 'amr@gmail.com', password: 'password');
//   await authService.loginWithJWT(
//       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjVlY2NjMmFlLTc4MWQtNDk3NS1iNTBmLTk1MzU3YWFhNGRjNSIsImVtYWlsIjoiYWhtZWRAZ21haWwuY29tIiwiaWF0IjoxNjg0MDgwNzMxLCJleHAiOjE2OTE4NTY3MzF9.DZbn4t_Rw1kK-5treQVpTUhYOQAOP3TkTDG0KwbEvYk');
// }
