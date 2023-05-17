import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/errors/models/auth_errors.dart';
import 'package:dart_verse/errors/models/database_errors.dart';
import 'package:dart_verse/features/auth_db_provider/auth_db_provider.dart';
import 'package:dart_verse/services/auth/models/jwt_payload.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'controllers/secure_password.dart';
import 'models/auth_model.dart';

class AuthService {
  // final DbService _dbService;
  final AuthDbProvider _authDbProvider;
  // late JWTController _jwtController;
  // late AuthCollections _authCollections;

  AuthService(
    //  this._dbService,
    this._authDbProvider,
  ) {
    // _authCollections = AuthCollections(_app, _dbService);
    // _jwtController = JWTController(_app, _authCollections);
  }

  /// this will return a jwt for the user to use to sign in again without the need of the email and password again
  Future<String> registerUser({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
    String? customID,
  }) async {
    //! i want to add the functionality of reverting everything if an error occurred
    String id = customID ?? Uuid().v4();
    String passwordHash = SecurePassword(password).getPasswordHash();

    // first check if email already exists
    AuthModel? savedModel = await _authDbProvider.getUserByEmail(email);
    if (savedModel != null) {
      throw DuplicateEmailException();
    }
    // creating the jwt
    AuthModel authModel = AuthModel(
      id: id,
      email: email,
      passwordHash: passwordHash,
    );

    bool authSaved = await _authDbProvider.saveUserAuth(authModel);
    if (!authSaved) {
      throw DBWriteException('failed to register user');
    }
    if (userData != null) {
      var userDataSaved = await _authDbProvider.saveUserData(userData);
      if (!userDataSaved) {
        throw DBWriteException('failed to save user data');
      }
    }

    String jwtToken = await _authDbProvider.createJwtAndSave(id, email);

    return jwtToken;
  }

  Future<String> loginWithEmail({
    required String email,
    required String password,
  }) async {
    AuthModel? savedModel = await _authDbProvider.getUserByEmail(email);

    if (savedModel == null) {
      throw NoUserRegistered();
    }
    bool rightPassword =
        SecurePassword(password).checkPassword(savedModel.passwordHash);
    if (!rightPassword) {
      throw InvalidPassword();
    }
    String jwtToken =
        await _authDbProvider.createJwtAndSave(savedModel.id, email);

    return jwtToken;
  }

  /// if the jwt is valid and allowed then it will return true else false
  Future<bool> loginWithJWT(String jwt) async {
    // verify the jwt isn't manipulated
    var res = JWT.tryVerify(
        jwt, SecretKey(_authDbProvider.app.authSettings.jwtSecretKey));
    if (res == null) {
      return false;
    }
    // get the data from the jwt
    JWTPayloadModel model = JWTPayloadModel.fromJson(res.payload);

    // check for the jwt in the allowed jwt tokens and active
    bool jwtIsActive = await _authDbProvider.checkIfJwtIsActive(jwt, model.id);
    if (!jwtIsActive) {
      return jwtIsActive;
    }
    // check for the user id if it is a valid user
    AuthModel? authModel = await _authDbProvider.getUserByEmail(model.email);
    if (authModel == null) {
      return false;
    }
    // then allow the user to continue
    return true;
  }
}
