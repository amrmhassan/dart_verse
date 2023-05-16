// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'try2/data/datasource/memory_db.dart';
import 'try2/presentation/db_ref.dart';

void main(List<String> arguments) async {
  var db = memoryDb;
  var dbRef = DbRef(MemoryDB());
  var users = dbRef.collection('users');
  var user = await users.insertDoc({'name': 'user name', 'age': 22});
  var hobbies = user.collection('hobbies');
  var hobby = await hobbies.insertDoc({
    'hobbyName': 'Football',
    'skill': 5,
  });
  var hobbiesRef2 = user.collection('hobbies');
  var hobby2 = await hobbiesRef2.insertDoc({
    'hobbyName': 'Feather ball',
    'skill': 2,
  });
  print(db);
  print(await hobby.getData());
  print(await hobby2.getData());
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
