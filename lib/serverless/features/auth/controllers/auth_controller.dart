import 'dart:convert';

import 'package:auth_server/serverless/app/app.dart';
import 'package:auth_server/serverless/features/auth/models/auth_model.dart';
import 'package:auth_server/serverless/features/database/controllers/auth_read.dart';
import 'package:crypto/crypto.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthService {
  final App _app;
  const AuthService(this._app);

  // this should return a token for the user to use to sign in again without the need of the email and password again
  Future<AuthModel> registerUser({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
    String? customID,
  }) async {
    String authCollName = _app.authSettings.collectionName;
    String usersDataCollName = _app.userDataSettings.collectionName;
    String userId = customID ?? Uuid().v4();
    String passwordHash = _getPasswordHash(password);

    AuthModel authModel = AuthModel(
      userId: userId,
      email: email,
      passwordHash: passwordHash,
    );

    var data =
        await _app.getDB.collection(authCollName).insertOne(authModel.toJson());
    if (data.failure) {
      throw Exception('Cant sign user up');
    }
    if (userData != null) {
      await _app.getDB.collection(usersDataCollName).insert(userData);
    }

    return authModel;
  }

  Future<AuthModel> loginUser({
    required String email,
    required String password,
  }) async {
    String passwordHash = _getPasswordHash(password);
    AuthModel? savedModel = await AuthRead(_app).getByEmail(email);
    if (savedModel == null) {
      throw Exception('No user registered');
    }
    if (passwordHash != savedModel.passwordHash) {
      throw Exception('invalid credentials');
    }
    return savedModel;
  }

  String _getPasswordHash(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}
