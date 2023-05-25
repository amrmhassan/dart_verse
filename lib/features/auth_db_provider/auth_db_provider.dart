import 'package:dart_verse/services/auth/models/auth_model.dart';
import 'package:dart_verse/services/db_manager/db_service.dart';

import '../../settings/app/app.dart';

/// this is to provide the auth service with db provider
/// either memory or mongo db or other db to auth users
abstract class AuthDbProvider {
  final App app;
  final DbService dbService;
  const AuthDbProvider(this.app, this.dbService);
  Future<AuthModel?> getUserByEmail(String email);
  Future<AuthModel?> getUserById(String id);
  Future<bool> saveUserAuth(AuthModel authModel);
  Future<bool> saveUserData(Map<String, dynamic> userData);
  Future<String> createJwtAndSave(String id, String email);
  Future<void> saveJwt({required String id, required String jwt});
  Future<bool> checkIfJwtIsActive(String jwt, String id);
  Future<void> deleteAuthData(String id);
  Future<bool> allowNewJwt(int maximum);
}
