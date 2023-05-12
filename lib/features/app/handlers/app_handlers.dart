import 'dart:io';

import '../../auth/models/user_model.dart';

List<UserModel> users = [
  UserModel(
    name: 'Amr hassan',
    email: 'amr@gmail.com',
    age: 20,
  ),
];

class AppHandlers {
  static void hello(HttpRequest request, HttpResponse response) {
    response.write('Hello world');
  }

  static void login(HttpRequest request, HttpResponse response) {
    response.write('login');
  }

  static void register(HttpRequest request, HttpResponse response) {
    response.write('register');
  }
}
