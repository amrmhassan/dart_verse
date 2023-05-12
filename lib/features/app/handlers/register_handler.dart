import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../../../constants/collections.dart';
import '../../../constants/model_fields.dart';
import '../../../transformers/auth_transformer.dart';
import '../../../transformers/res_trans.dart';
import '../../auth/models/auth_model.dart';
import '../../read/auth_read.dart';
import '../../validation/auth_validation.dart';
import '../app.dart';

class RegisterHandler {
  void run(HttpRequest request, HttpResponse response) async {
    ResTrans resTrans = ResTrans(response);
    try {
      var body = await ReqTrans.decodeRequest(request, true);
      if (body == null) {
        resTrans.sendInvalidInput('invalid body');

        return;
      }
      //? receiving data
      String? name = body[ModelFields.name];
      String? email = body[ModelFields.email];
      String? password = body[ModelFields.password];
      if (name == null || email == null || password == null) {
        resTrans.sendInvalidInput('please provide full info needed');
        return;
      }
      //? validation
      String? nameError = NameValidation().error(name);
      String? emailError = EmailValidation().error(email);
      String? passwordError = PasswordValidation().error(password);
      if (nameError != null) {
        resTrans.sendInvalidInput(nameError);
        return;
      }
      if (emailError != null) {
        resTrans.sendInvalidInput(emailError);

        return;
      }
      if (passwordError != null) {
        resTrans.sendInvalidInput(passwordError);

        return;
      }
      //? check if email already exists
      AuthModel? savedModel = await AuthRead().getByEmail(email);
      if (savedModel != null) {
        resTrans.sendInvalidInput('email already exists');

        return;
      }
      Digest passwordHash = sha256.convert(utf8.encode(password));
      AuthModel authModel = AuthModel(
        email: email,
        name: name,
        passwordHash: passwordHash.toString(),
      );
      //? save to database
      await app.db.collection(DbColl.auth).insert(authModel.toJson());
      String resBody = authModel.toString();
      response.write(resBody);
    } catch (e) {
      resTrans.sendInternalError(e);
    }
  }
}
