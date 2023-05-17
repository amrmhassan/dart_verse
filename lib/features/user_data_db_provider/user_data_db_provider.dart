import '../../services/db_manager/db_service.dart';
import '../../settings/app/app.dart';

abstract class UserDataDbProvider {
  final App app;
  final DbService dbService;
  const UserDataDbProvider(this.app, this.dbService);

  /// update user data with the updateDoc and returns the new updated user data map
  /// will override only the values presented in the update Doc and leave all other properties as they are `(the _id can't be changed and can't be deleted)`
  /// if the _id isn't presented in the newDoc no worries it will be the same
  /// if the user data doesn't exist it will create a new document with the provided user data
  Future<Map<String, dynamic>?> updateUserData(
    String userId,
    Map<String, dynamic> updateDoc,
  );

  /// delete user data without the auth data(user can still login)
  Future<Map<String, dynamic>?> deleteUserData(String userId);

  /// sets the current user data to the newDoc
  /// remove the old document and add the newDoc instead `(the _id can't be changed and can't be deleted)`
  /// if the _id isn't presented in the newDoc no worries it will be the same
  /// if the user data doesn't exist it will create a new document with the provided user data
  Future<Map<String, dynamic>?> setUserData(
    String userId,
    Map<String, dynamic> newDoc,
  );
}
