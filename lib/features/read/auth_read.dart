import 'package:auth_server/constants/collections.dart';
import 'package:auth_server/constants/model_fields.dart';
import 'package:auth_server/features/app/app.dart';
import 'package:auth_server/features/auth/models/auth_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthRead {
  Future<AuthModel?> getByEmail(String email) async {
    var res = await app.db
        .collection(DbColl.auth)
        .findOne(where.eq(ModelFields.email, email));
    if (res == null) return null;
    try {
      return AuthModel.fromJson(res);
    } catch (e) {
      return null;
    }
  }
}
