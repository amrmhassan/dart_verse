import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/services/db_manager/db_service.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../../services/auth/models/auth_model.dart';

class AuthRead {
  final App _app;
  final DbService _dbService;
  const AuthRead(this._app, this._dbService);

  Future<AuthModel?> getByEmail(String email) async {
    var res = await _dbService.getMongoDB
        .collection(_app.authSettings.collectionName)
        .findOne(where.eq(ModelFields.email, email));
    if (res == null) return null;
    try {
      return AuthModel.fromJson(res);
    } catch (e) {
      return null;
    }
  }
}
