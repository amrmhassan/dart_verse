import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/constants/reserved_keys.dart';
import 'package:dart_verse/errors/models/auth_errors.dart';
import 'package:dart_verse/errors/models/database_errors.dart';
import 'package:dart_verse/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse/services/auth/models/jwt_payload.dart';
import 'package:dart_verse/services/service.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'controllers/secure_password.dart';
import 'models/auth_model.dart';

class AuthService implements DVService {
  final AuthDbProvider authDbProvider;

  AuthService(
    this.authDbProvider,
  );

  /// this will return a jwt for the user to use to sign in again without the need of the email and password again
  Future<String> registerUser({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
    String? customUserID,
  }) async {
    //! i want to add the functionality of reverting everything if an error occurred
    String id = customUserID ?? ObjectId().toHexString();

    String passwordHash = SecurePassword(password).getPasswordHash();

    // first check if email already exists
    AuthModel? savedModel = await authDbProvider.getUserByEmail(email);
    if (savedModel != null) {
      throw DuplicateEmailException();
    }
    AuthModel authModel = AuthModel(
      id: id,
      email: email,
      passwordHash: passwordHash,
    );
    // creating the jwt
    bool authModelSaved = await authDbProvider.saveUserAuth(authModel);

    if (!authModelSaved) {
      throw DBWriteException('failed to register user');
    }
    if (userData != null) {
      userData[DBRKeys.id] = authModel.id;
      var userDataSaved = await authDbProvider.saveUserData(userData);
      if (!userDataSaved) {
        throw DBWriteException('failed to save user data');
      }
    }

    String jwtToken =
        await authDbProvider.createJwtAndSave(authModel.id, email);

    return jwtToken;
  }

  Future<String> loginWithEmail({
    required String email,
    required String password,
  }) async {
    AuthModel? savedModel = await authDbProvider.getUserByEmail(email);

    if (savedModel == null) {
      throw NoUserRegisteredException();
    }
    bool rightPassword =
        SecurePassword(password).checkPassword(savedModel.passwordHash);
    if (!rightPassword) {
      throw InvalidPassword();
    }
    String jwtToken =
        await authDbProvider.createJwtAndSave(savedModel.id, email);

    return jwtToken;
  }

  /// if the jwt is valid and allowed then it will return true else false
  Future<bool> loginWithJWT(String jwt) async {
    // verify the jwt isn't manipulated
    var res = JWT.tryVerify(
        jwt, SecretKey(authDbProvider.app.authSettings.jwtSecretKey));
    if (res == null) {
      return false;
    }
    // get the data from the jwt
    JWTPayloadModel model = JWTPayloadModel.fromJson(res.payload);

    // check for the jwt in the allowed jwt tokens and active
    bool jwtIsActive = await authDbProvider.checkIfJwtIsActive(jwt, model.id);
    if (!jwtIsActive) {
      return jwtIsActive;
    }
    // check for the user id if it is a valid user
    AuthModel? authModel = await authDbProvider.getUserByEmail(model.email);
    if (authModel == null) {
      return false;
    }
    // then allow the user to continue
    return true;
  }

  /// delete auth user data with the jwt data
  Future<void> deleteAuthData(String userId) async {
    //! here delete the user auth data
    return authDbProvider.deleteAuthData(userId);
  }
}
