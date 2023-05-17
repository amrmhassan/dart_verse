import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/errors/models/auth_errors.dart';
import 'package:dart_verse/errors/models/database_errors.dart';
import 'package:dart_verse/features/auth/controllers/auth_collections.dart';
import 'package:dart_verse/features/auth/controllers/jwt_controller.dart';
import 'package:dart_verse/features/auth/controllers/secure_password.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/features/auth/models/auth_model.dart';
import 'package:dart_verse/features/app_database/controllers/auth_read.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthService {
  final App _app;

  late JWTController _jwtController;
  late AuthRead _authRead;
  late AuthCollections _authCollections;

  AuthService(this._app) {
    _authCollections = AuthCollections(_app);
    _authRead = AuthRead(_app);
    _jwtController = JWTController(_app, _authCollections);
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
    AuthModel? savedModel = await _authRead.getByEmail(email);
    if (savedModel != null) {
      throw DuplicateEmailException();
    }
    // creating the jwt
    AuthModel authModel = AuthModel(
      id: id,
      email: email,
      passwordHash: passwordHash,
    );

    var authData = await _authCollections.auth.insertOne(authModel.toJson());
    if (authData.failure) {
      throw DBWriteException('failed to register user');
    }
    if (userData != null) {
      var userDataRes = await _authCollections.usersData.insertOne(userData);
      if (userDataRes.failure) {
        throw DBWriteException('Failed to save user data');
      }
    }
    String jwtToken =
        await _jwtController.createJwtAndSave(id: id, email: email);

    return jwtToken;
  }

  Future<String> loginWithEmail({
    required String email,
    required String password,
  }) async {
    AuthModel? savedModel = await _authRead.getByEmail(email);
    if (savedModel == null) {
      throw NoUserRegistered();
    }
    bool rightPassword =
        SecurePassword(password).checkPassword(savedModel.passwordHash);
    if (!rightPassword) {
      throw InvalidPassword();
    }
    String jwtToken =
        await _jwtController.createJwtAndSave(id: savedModel.id, email: email);

    return jwtToken;
  }

  Future<void> loginWithJWT(String jwt) async {
    // verify the jwt isn't manipulated
    // get the data from the jwt
    // check for the jwt in the allowed jwt tokens and active
    // check for the user id if it is a valid user
    // then allow the user to continue
    var res = JWT.tryVerify(jwt, SecretKey(_app.authSettings.jwtSecretKey));
    print(res);
  }
}
