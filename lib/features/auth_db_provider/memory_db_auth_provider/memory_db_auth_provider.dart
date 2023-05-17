import 'package:dart_verse/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse/services/auth/controllers/jwt_controller.dart';
import 'package:dart_verse/services/auth/models/auth_model.dart';

import '../../../constants/model_fields.dart';
import '../../../services/db_manager/db_service.dart';
import '../../../settings/app/app.dart';

class MemoryDbAuthProvider extends AuthDbProvider {
  @override
  final App app;
  @override
  final DbService dbService;
  MemoryDbAuthProvider(this.app, this.dbService) : super(app, dbService);

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
    var data = dbService.memoryDbController
        .collection(app.authSettings.collectionName)
        .getDocWhere(
          (element) => element[ModelFields.email] == email,
        )
        ?.getData();
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
      dbService.memoryDbController
          .collection(app.authSettings.collectionName)
          .insertDoc(authModel.toJson());

      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      dbService.memoryDbController
          .collection(app.userDataSettings.collectionName)
          .insertDoc(userData);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> saveJwt({required String id, required String jwt}) async {
    // i just want to add the jwt to the user collection
    var data = dbService.memoryDbController
        .collection(app.authSettings.activeJWTCollName)
        .getDocRefById(id)
        ?.getData();
    List<String> jwts = data?[ModelFields.activeTokens] ?? [];
    // checking if saved jwts list contains the new jwt to skip adding it
    if (jwts.any((element) => element == jwt)) {
      return;
    }
    jwts.add(jwt);
    dbService.memoryDbController
        .collection(app.authSettings.activeJWTCollName)
        .doc(id)
        .set({
      ModelFields.activeTokens: jwts,
    });
  }

  @override
  Future<bool> checkIfJwtIsActive(String jwt, String id) async {
    var data = dbService.memoryDbController
        .collection(app.authSettings.activeJWTCollName)
        .getDocRefById(id)
        ?.getData();
    List<String> jwts = data?[ModelFields.activeTokens] ?? [];
    // checking if saved jwts list contains the new jwt to skip adding it
    if (jwts.any((element) => element == jwt)) {
      return true;
    }
    return false;
  }
}
