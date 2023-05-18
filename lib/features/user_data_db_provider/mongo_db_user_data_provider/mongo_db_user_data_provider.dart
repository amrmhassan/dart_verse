// ignore_for_file: overridden_fields

import 'package:dart_verse/constants/reserved_keys.dart';
import 'package:dart_verse/features/repo/mongo_db_repo_provider.dart';
import 'package:dart_verse/features/user_data_db_provider/user_data_db_provider.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../services/db_manager/db_service.dart';
import '../../../settings/app/app.dart';

class MongoDbUserDataProvider extends UserDataDbProvider
    implements MongoDbRepoProvider {
  @override
  final App app;
  @override
  final DbService dbService;
  MongoDbUserDataProvider(this.app, this.dbService) : super(app, dbService);
  @override
  Future<Map<String, dynamic>?> deleteUserData(
    String userId,
    bool deleteAuthData,
    Future<void> Function() deleteAuthDataMethod,
  ) async {
    var res = await dbService.mongoDbController
        .collection(app.userDataSettings.collectionName)
        .deleteOne(where.eq(DBRKeys.id, userId));

    if (deleteAuthData) {
      //! here delete the auth data and jwt data
      await deleteAuthDataMethod();
    }
    return res.document;
  }

  @override
  Future<Map<String, dynamic>> setUserData(
      String userId, Map<String, dynamic> newDoc) async {
    var res = await dbService.mongoDbController
        .collection(app.userDataSettings.collectionName)
        .doc(userId)
        .set(newDoc);
    return Future.value(res.document);
  }

  @override
  Future<Map<String, dynamic>?> updateUserData(
    String userId,
    Map<String, dynamic> updateDoc,
  ) async {
    var res = await dbService.mongoDbController
        .collection(app.userDataSettings.collectionName)
        .doc(userId)
        .update(updateDoc);
    return Future.value(res.document);
  }
}