// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'package:dart_verse/features/db_manager/data/datasource/memory_db.dart';
import 'package:dart_verse/features/db_manager/presentation/db_ref.dart';

void main(List<String> arguments) async {
  var dbRef = DbRef(MemoryDB());
  var users = dbRef.collection('users');
  var user = await users.insertDoc({'name': 'user name', 'age': 22});
  var hobbies = user.collection('hobbies');
  var hobby = await hobbies.insertDoc({
    'hobbyName': 'Football',
    'skill': 5,
  });

  print(await hobby.getData());
  await hobby.set({'skill': 4});
  print(hobby);
  print(await hobby.getData());

  print(hobby);
}
//? before applying the new data manager in the app
//? just find a way to handle querying with the mongodb 
//? and find a way to make use of the whole mongo_dart lib or the querying in database sourse
//?
//?
//?
//? you can make a tree of the data sources and classes you will need