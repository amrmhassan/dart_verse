import 'package:dart_verse/serverless/errors/models/auth_errors.dart';
import 'package:dart_verse/serverless/errors/models/database_errors.dart';
import 'package:dart_verse/serverless/features/auth/controllers/auth_collections.dart';
import 'package:dart_verse/serverless/features/auth/controllers/jwt_controller.dart';
import 'package:dart_verse/serverless/features/auth/controllers/secure_password.dart';
import 'package:dart_verse/serverless/settings/app.dart';
import 'package:dart_verse/serverless/features/auth/models/auth_model.dart';
import 'package:dart_verse/serverless/features/database/controllers/auth_read.dart';
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

  // this should return a token for the user to use to sign in again without the need of the email and password again
  Future<String> registerUser({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
    String? customID,
  }) async {
    String usersDataCollName = _app.userDataSettings.collectionName;
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

    String jwtToken = await _jwtController.createJwt(id: id, email: email);
    return jwtToken;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    AuthModel? savedModel = await _authRead.getByEmail(email);
    if (savedModel == null) {
      throw Exception('No user registered');
    }
    bool rightPassword =
        SecurePassword(password).checkPassword(savedModel.passwordHash);
    if (rightPassword) {
      throw Exception('invalid credentials');
    }
    String jwtToken =
        await _jwtController.createJwt(id: savedModel.id, email: email);

    return jwtToken;
  }

  Future<void> loginWithJWT(String jwt) async {
    throw UnimplementedError();
  }
}
