import 'dart:convert';
import 'dart:io';

import 'package:auth_server/features/app/handlers/register_handler.dart';
import 'package:auth_server/features/auth/models/auth_model.dart';
import 'package:auth_server/features/read/auth_read.dart';
import 'package:auth_server/transformers/res_trans.dart';
import 'package:crypto/crypto.dart';

import '../../../constants/model_fields.dart';
import '../../../transformers/auth_transformer.dart';
import '../../validation/auth_validation.dart';

class AppHandlers {
  static void hello(HttpRequest request, HttpResponse response) {
    response.write('Hello world');
  }

  static void login(HttpRequest request, HttpResponse response) async {
    ResTrans resTrans = ResTrans(response);
    try {
      //? receiving data
      var body = await ReqTrans.decodeRequest(request, true);
      if (body == null) {
        resTrans.sendInvalidInput('invalid body');

        return;
      }
      String? email = body[ModelFields.email];
      String? password = body[ModelFields.password];
      if (email == null || password == null) {
        resTrans.sendInvalidInput('please provide full info needed');
        return;
      }
      //? validation
      String? emailError = EmailValidation().error(email);
      String? passwordError = PasswordValidation().error(password);

      if (emailError != null) {
        resTrans.sendInvalidInput(emailError);

        return;
      }
      if (passwordError != null) {
        resTrans.sendInvalidInput(passwordError);
        return;
      }
      //? check for inputs
      String passwordHash = sha256.convert(utf8.encode(password)).toString();
      AuthModel? savedModel = await AuthRead().getByEmail(email);
      if (savedModel == null) {
        resTrans.sendForbiddenInput('no user registered');
        return;
      }
      if (passwordHash != savedModel.passwordHash) {
        resTrans.sendForbiddenInput('invalid credentials');
        return;
      }
      resTrans.sendSuccess(savedModel.toString());
    } catch (e) {
      resTrans.sendInternalError(e);
      return;
    }
  }

  static void register(HttpRequest request, HttpResponse response) async {
    return RegisterHandler().run(request, response);
  }
}
