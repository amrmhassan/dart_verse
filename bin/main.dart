// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'try2/data/datasource/memory_db.dart';
import 'try2/presentation/db_ref.dart';

void main(List<String> arguments) async {
  var ref = DbRef(MemoryDB())
      .collection('users')
      .doc('user1')
      .collection('hobbies')
      .doc('hobby1')
      .collection('tracks')
      .doc('track1');
  print(ref);
}
  // var collection = DbRef().collection('users');
  // collection.ref
  // var doc = collection.doc('hobbies');
  // var hobbyDoc = doc.collection('hobbies').insertOne({
  //   '_id': 'running',
  //   'name': 'Running Skill',
  //   'skills': 'Very skilled',
  // });
  // var userDoc = DbRef().collection('users').getAllDocuments().first;
  // String userId = userDoc['_id'];
  // var finalDoc = DbRef()
  //     .collection('users')
  //     .doc(userId)
  //     .collection('hobbies')
  //     .doc(hobbyDoc.id)
  //     .getData();

  // print(finalDoc);

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
