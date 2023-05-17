import 'package:dart_verse/features/auth_db_provider/memory_db_auth_provider/memory_db_auth_provider.dart';
import 'package:dart_verse/features/auth_db_provider/mongo_db_auth_provider/mongo_db_auth_provider.dart';
import 'package:dart_verse/features/user_data_db_provider/memory_db_user_data_provider/memory_db_user_data_provider.dart';
import 'package:dart_verse/features/user_data_db_provider/mongo_db_user_data_provider/mongo_db_user_data_provider.dart';
import 'package:dart_verse/features/user_data_db_provider/user_data_db_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/service.dart';

import '../../errors/models/user_data_errors.dart';

class UserDataService implements DVService {
  final AuthService _authService;
  UserDataDbProvider? _userDataDbProvider;

  UserDataService(this._authService) {
    if (_authService.authDbProvider is MemoryDbAuthProvider) {
      _userDataDbProvider = MemoryDbUserDataProvider(
        _authService.authDbProvider.app,
        _authService.authDbProvider.dbService,
      );
    } else if (_authService.authDbProvider is MongoDbAuthProvider) {
      _userDataDbProvider = MongoDbUserDataProvider(
        _authService.authDbProvider.app,
        _authService.authDbProvider.dbService,
      );
    } else {
      throw UserDataServiceDependOnAuthServiceException();
    }
  }

  UserDataDbProvider get userDataDbProvider {
    if (_userDataDbProvider == null) {
      throw UserDataServiceDependOnAuthServiceException();
    }
    return _userDataDbProvider!;
  }

  Future<Map<String, dynamic>?> updateUserData(
    String userId,
    Map<String, dynamic> updateDoc,
  ) {
    return userDataDbProvider.updateUserData(userId, updateDoc);
  }

  Future<Map<String, dynamic>?> deleteUserData(String userId) {
    return userDataDbProvider.deleteUserData(userId);
  }

  Future<Map<String, dynamic>?> setUserData(
    String userId,
    Map<String, dynamic> newDoc,
  ) {
    return userDataDbProvider.setUserData(userId, newDoc);
  }
}
