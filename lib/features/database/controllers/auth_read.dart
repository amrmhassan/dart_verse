import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/settings/app.dart';
import 'package:dart_verse/features/auth/models/auth_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthRead {
  final App _app;
  const AuthRead(this._app);

  Future<AuthModel?> getByEmail(String email) async {
    var res = await _app.getDB
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
