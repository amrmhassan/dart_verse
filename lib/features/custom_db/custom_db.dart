// import 'dart:convert';
// import 'dart:io';

// import 'package:uuid/uuid.dart';

// void test() async {
//   List<Map<String, dynamic>> users = [
//     {'name': 'Hossam', 'age': 7, 'id': Uuid().v4()},
//     {'name': 'Esraa', 'age': 19, 'id': Uuid().v4()}
//   ];
//   List<Map<String, dynamic>> users2 = [
//     {'name': 'Amr', 'age': 22, 'id': Uuid().v4()},
//     {'name': 'Osama', 'age': 16, 'id': Uuid().v4()}
//   ];
//   // DbController controller = DbController(users);
//   // await controller.save();

//   DbController controller = DbController();
//   await controller.connect();
//   DateTime before = DateTime.now();
//   for (var i = 0; i < 10; i++) {
//     await controller.save(users);
//   }
//   await controller.closeDb();
//   // var user = await controller.getUser('a8c2d5bf-f073-40ee-a081-a5b4e2994e9a');
//   // print(user);
//   DateTime after = DateTime.now();
//   print(after.difference(before).inMicroseconds / 1000);
// }

// class DbController {
//   // List<IndexModel> indecies = [];
//   late RandomAccessFile raf;
//   Future<void> connect() async {
//     raf = await File('users.db').open(mode: FileMode.append);
//   }

//   Future<void> closeDb() async {
//     await raf.close();
//   }

//   Future save(List<Map<String, dynamic>> users) async {
//     // int start = raf.lengthSync();
//     for (var user in users) {
//       var jsonUser = json.encode(user);
//       List<int> userBytes = utf8.encode(jsonUser);
//       // int bytesLength = userBytes.length;
//       await raf.writeFrom(userBytes);
//       // IndexModel index =
//       //     IndexModel(id: user['id'], boundaries: [start, bytesLength + start]);
//       // indecies.add(index);
//       // start += userBytes.length;
//     }
//   }

//   // Future _saveIndices() async {
//   // var raf = await File('indecies.json').open(mode: FileMode.write);
//   // var jsonIndices = json.encode(indecies.map((e) => e.toJson()).toList());
//   // raf.writeStringSync(jsonIndices);
//   // raf.closeSync();
//   // }

//   // void _loadIndecies() {
//   // try {
//   //   var raf = File('indecies.json');
//   //   var loadedIndices = json.decode(raf.readAsStringSync()) as List;
//   //   indecies.addAll(loadedIndices.cast().map((e) => IndexModel.fromJSON(e)));
//   // } catch (e) {
//   //   //
//   // }
//   // }

//   // Future<Map<String, dynamic>?> getUser(String id) async {
//   //   List<int> boundaries;
//   //   try {
//   //     boundaries = indecies
//   //         .firstWhere(
//   //           (element) => element.id == id,
//   //         )
//   //         .boundaries;
//   //   } catch (e) {
//   //     return null;
//   //   }
//   //   int start = boundaries[0];
//   //   int end = boundaries[1];
//   //   var raf = File('users.db').openRead(start, end);
//   //   List<int> content = [];
//   //   await for (var chunk in raf) {
//   //     content.addAll(chunk);
//   //   }
//   //   return json.decode(utf8.decode(content));
//   // }
// }

// // class IndexModel {
// //   final String id;
// //   final List<int> boundaries;
// //   const IndexModel({
// //     required this.id,
// //     required this.boundaries,
// //   });

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'boundaries': boundaries,
// //     };
// //   }

// //   static IndexModel fromJSON(Map<String, dynamic> obj) {
// //     return IndexModel(
// //       id: obj['id'],
// //       boundaries: (obj['boundaries'] as List).cast(),
// //     );
// //   }
// // }
