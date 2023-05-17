// ignore_for_file: overridden_fields

import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/constants/reserved_keys.dart';
import 'package:dart_verse/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse/services/auth/models/auth_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../services/auth/controllers/jwt_controller.dart';
import '../../../services/db_manager/db_service.dart';
import '../../../settings/app/app.dart';

class MongoDbAuthProvider extends AuthDbProvider {
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
          .insertOne(authModel.toJson());

      bool failure = docRef.failure || docRef.isFailure;
      if (failure) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      var docRef = await dbService.mongoDbController
          .collection(app.userDataSettings.collectionName)
          .insertOne(userData);
      bool failure = docRef.failure || docRef.isFailure;
      if (failure) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveJwt({required String id, required String jwt}) async {
    // i just want to add the jwt to the user collection
    var data = await dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName)
        .findOne(where.eq(DBRKeys.id, id));

    List<String> jwts =
        ((data?[ModelFields.activeTokens] ?? []) as List).cast();
    // checking if saved jwts list contains the new jwt to skip adding it
    if (jwts.any((element) => element == jwt)) {
      return;
    }
    jwts.add(jwt);
    await dbService.mongoDbController
        .collection(app.authSettings.activeJWTCollName)
        .doc(id)
        .set({
      ModelFields.activeTokens: jwts,
    });
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
}
