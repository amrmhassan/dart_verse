import 'package:dart_verse/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse/services/auth/models/auth_model.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/services/db_manager/db_service.dart';

class MongoDbAuthProvider implements AuthDbProvider {
  @override
  Future<String> createJwtAndSave(String id, String email) {
    // TODO: implement createJwtAndSave
    throw UnimplementedError();
  }

  @override
  Future<AuthModel?> getUserByEmail(String email) {
    // TODO: implement getUserByEmail
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUserAuth(AuthModel authModel) {
    // TODO: implement saveUserAuth
    throw UnimplementedError();
  }

  @override
  Future<bool> saveUserData(Map<String, dynamic> userData) {
    // TODO: implement saveUserData
    throw UnimplementedError();
  }

  @override
  // TODO: implement app
  App get app => throw UnimplementedError();

  @override
  // TODO: implement dbService
  DbService get dbService => throw UnimplementedError();

  @override
  Future<void> saveJwt({required String id, required String jwt}) {
    // TODO: implement saveJwt
    throw UnimplementedError();
  }

  @override
  Future<bool> checkIfJwtIsActive(String jwt, String id) {
    // TODO: implement checkIfJwtIsActive
    throw UnimplementedError();
  }
}
