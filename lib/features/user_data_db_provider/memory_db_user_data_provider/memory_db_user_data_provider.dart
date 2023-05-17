import 'package:dart_verse/features/repo/memory_db_repo_provider.dart';

import '../user_data_db_provider.dart';

class MemoryDbUserDataProvider extends UserDataDbProvider
    implements MemoryDbRepoProvider {
  MemoryDbUserDataProvider(super.app, super.dbService);

  @override
  Future<Map<String, dynamic>> deleteUserData(String userId) {
    // TODO: implement deleteUserData
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> setUserData(
      String userId, Map<String, dynamic> newDoc) {
    // TODO: implement setUserData
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> updateUserData(
      String userId, Map<String, dynamic> updateDoc) {
    // TODO: implement updateUserData
    throw UnimplementedError();
  }
}
