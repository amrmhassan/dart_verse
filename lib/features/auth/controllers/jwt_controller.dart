import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/constants/logger.dart';
import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/errors/models/database_errors.dart';
import 'package:dart_verse/features/auth/controllers/auth_collections.dart';
import 'package:dart_verse/settings/app.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../models/jwt_payload.dart';

class JWTController {
  final App _app;
  final AuthCollections _authCollections;

  const JWTController(this._app, this._authCollections);

  Future<String> createJwtAndSave({
    required String id,
    required String email,
  }) async {
    String key = _app.authSettings.jwtSecretKey;
    JWTPayloadModel jwtPayload = JWTPayloadModel(
      id: id,
      email: email,
    );
    var jwt = JWT(jwtPayload.toJson());
    String signedJWT = jwt.sign(
      // RSAPrivateKey(key),
      SecretKey(key),
      expiresIn: _app.authSettings.authExpireAfter,
      // algorithm: JWTAlgorithm.RS256,
    );
    await _saveJWT(id: id, jwt: signedJWT);
    return signedJWT;
  }

  Future<void> _saveJWT({
    required String id,
    required String jwt,
  }) async {
    try {
      var selector = where.eq(ModelFields.id, id);
      var update = modify.push(ModelFields.activeTokens, jwt);
      await _authCollections.activeJWTs.updateOne(
        selector,
        update,
        upsert: true,
      );
    } catch (e) {
      logger.e(e);
      throw DBWriteException('failed to save active jwt');
    }
  }
}
