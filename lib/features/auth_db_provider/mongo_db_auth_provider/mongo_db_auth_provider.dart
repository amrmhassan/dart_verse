// ignore_for_file: overridden_fields

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/constants/reserved_keys.dart';
import 'package:dart_verse/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse/features/repo/mongo_db_repo_provider.dart';
import 'package:dart_verse/services/auth/models/auth_model.dart';
import 'package:googleapis/binaryauthorization/v1.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../errors/models/auth_errors.dart';
import '../../../services/auth/controllers/jwt_controller.dart';
import '../../../services/db_manager/db_service.dart';
import '../../../settings/app/app.dart';

class MongoDbAuthProvider extends AuthDbProvider
    implements MongoDbRepoProvider {
  @override
  final App app;
  @override
  final DbService dbService;
  MongoDbAuthProvider(this.app, this.dbService) : super(app, dbService);

  @override
  Future<String> createJwtAndSave(String id, String email) {
    JWTController jwtController = JWTController(app);
    return jwtController.createJwtAndSave(
      id: id,
      email: email,
      saveJwt: saveJwt,
    );
  }

  @override
  Future<AuthModel?> getUserByEmail(String email) async {
    var data = await dbService.mongoDbController
        .collection(app.authSettings.collectionName)
        .findOne(where.eq(ModelFields.email, email));

    if (data == null) return null;
    try {
      return AuthModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> saveUserAuth(AuthModel authModel) async {
    try {
      var docRef = await dbService.mongoDbController
          .collection(app.authSettings.collectionName)
          .insertOne(authModel.toJsonWith_Id());

      bool failure = docRef.failure;
      if (failure) {
        return false;
      }
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      var docRef = await dbService.mongoDbController
          .collection(app.userDataSettings.collectionName)
          .insertOne(userData);
      bool failure = docRef.failure;
      if (failure) {
        return false;
      }

      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveJwt({required String id, required String jwt}) async {
    //? first checks for saved jwts
    var collection = dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName);

// Check if the active JWTs count has exceeded the limit of 5
    var countQuery =
        where.eq(DBRKeys.id, id).fields([ModelFields.activeTokens]);
    var countResult = await collection.findOne(countQuery);

    var fetchedTokens = (countResult?[ModelFields.activeTokens] as List?) ?? [];
    int activeTokensLength = 0;
    for (var token in fetchedTokens) {
      try {
        JWT.verify(token, SecretKey(app.authSettings.jwtSecretKey));
        activeTokensLength++;
      } catch (e) {
        continue;
      }
    }
    if (activeTokensLength >= app.authSettings.maximumActiveJwts) {
      throw LoginExceedException();
    }
    // i just want to add the jwt to the user collection
    // var data = await dbService.mongoDbController
    //     //! here instead of getting the data from the remote db
    //     //! just make modification query to the db to add the new jwt to the list
    //     .collection(app.authSettings.activeJWTCollName)
    //     .findOne(where.eq(DBRKeys.id, id));

    // List<String> jwts =
    //     ((data?[ModelFields.activeTokens] ?? []) as List).cast();
    // // checking if saved jwts list contains the new jwt to skip adding it
    // if (jwts.any((element) => element == jwt)) {
    //   return;
    // }

    var pushQuery = where.eq(DBRKeys.id, id);
    var pushUpdate = modify.push(ModelFields.activeTokens, jwt);

    await dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName)
        .update(pushQuery, pushUpdate, upsert: true);

    // jwts.add(jwt);
    // await dbService.mongoDbController
    //     .collection(app.authSettings.activeJWTCollName)
    //     .doc(id)
    //     .set({
    //   ModelFields.activeTokens: jwts,
    // });
  }

  @override
  Future<bool> checkIfJwtIsActive(String jwt, String id) async {
    var data = await dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName)
        .findOne(where.eq(DBRKeys.id, id));

    List<String> jwts =
        ((data?[ModelFields.activeTokens] ?? []) as List).cast();
    // checking if saved jwts list contains the new jwt to skip adding it
    if (jwts.any((element) => element == jwt)) {
      return true;
    }
    return false;
  }

  @override
  Future<void> deleteAuthData(String id) async {
    var res = await dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName)
        .doc(id)
        .delete();
    if (res.failure) {
      throw Exception('cant delete jwt data for the user');
    }
    var userAuthRes = await dbService.mongoDbController
        .collection(app.authSettings.collectionName)
        .doc(id)
        .delete();
    if (userAuthRes.failure) {
      throw Exception('cant delete user auth data for the user');
    }
  }

  @override
  Future<AuthModel?> getUserById(String id) async {
    var data = await dbService.mongoDbController
        .collection(app.authSettings.collectionName)
        .findOne(where.eq(DBRKeys.id, id));

    if (data == null) return null;
    try {
      return AuthModel.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> allowNewJwt(int maximum) {
    // TODO: implement allowNewJwt
    throw UnimplementedError();
  }
}
