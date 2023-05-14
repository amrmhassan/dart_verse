import 'dart:convert';

import 'package:auth_server/serverless/constants/model_fields.dart';
import 'package:auth_server/serverless/settings/app.dart';
import 'package:auth_server/serverless/features/auth/models/auth_model.dart';
import 'package:auth_server/serverless/features/auth/models/jwt_payload.dart';
import 'package:auth_server/serverless/features/database/controllers/auth_read.dart';
import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthService {
  final App _app;
  const AuthService(this._app);

  // this should return a token for the user to use to sign in again without the need of the email and password again
  Future<AuthModel> registerUser({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
    String? customID,
  }) async {
    String authCollName = _app.authSettings.collectionName;
    String usersDataCollName = _app.userDataSettings.collectionName;
    String userId = customID ?? Uuid().v4();
    String passwordHash = _getPasswordHash(password);

    // first check if email already exists
    AuthModel? savedModel = await AuthRead(_app).getByEmail(email);
    if (savedModel != null) {
      throw Exception('Email already exists');
    }
    // creating the jwt
    String jwtToken = _createJwt(userId: userId, email: email);
    AuthModel authModel = AuthModel(
      id: userId,
      email: email,
      passwordHash: passwordHash,
      jwt: jwtToken,
    );

    var data =
        await _app.getDB.collection(authCollName).insertOne(authModel.toJson());
    if (data.failure) {
      throw Exception('Cant sign user up');
    }
    if (userData != null) {
      await _app.getDB.collection(usersDataCollName).insert(userData);
    }

    return authModel;
  }

  Future<AuthModel> loginUser({
    required String email,
    required String password,
  }) async {
    String passwordHash = _getPasswordHash(password);
    AuthModel? savedModel = await AuthRead(_app).getByEmail(email);
    if (savedModel == null) {
      throw Exception('No user registered');
    }
    if (passwordHash != savedModel.passwordHash) {
      throw Exception('invalid credentials');
    }
    return savedModel;
  }

  String _getPasswordHash(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

//! i stopped here at creating the user web token
  Future<void> updateUserJwt(AuthModel authModel, String jwt) async {
    await _app.getDB.collection(_app.authSettings.collectionName).update(
          where.eq(ModelFields.id, authModel.id),
          authModel.toJson(),
        );
  }

  String _createJwt({
    required String userId,
    required String email,
  }) {
    String key = _app.authSettings.jwtSecretKey;
    JWTPayloadModel jwtPayload = JWTPayloadModel(
      userId: userId,
      email: email,
    );
    var jwt = JWT(
      jwtPayload.toJson(),
      issuer: userId,
    );
    String signed = jwt.sign(
      SecretKey(key),
      expiresIn: _app.authSettings.authExpireAfter,
      algorithm: JWTAlgorithm.ES256,
    );
    return signed;
  }
}
