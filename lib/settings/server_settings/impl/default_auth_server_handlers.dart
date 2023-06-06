import 'dart:async';

import 'package:dart_express/dart_express.dart';
import 'package:dart_express/dart_express/server/repo/passed_http_entity.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dart_verse/constants/model_fields.dart';
import 'package:dart_verse/errors/models/auth_errors.dart';
import 'package:dart_verse/errors/models/server_errors.dart';
import 'package:dart_verse/errors/serverless_exception.dart';
import 'package:dart_verse/features/email_verification/repo/email_verification_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/email_service/email_service.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_handlers.dart';
import 'package:mailer/mailer.dart';

import '../repo/auth_body_keys.dart';
import '../utils/send_response.dart';

class DefaultAuthServerHandlers implements AuthServerHandlers {
  FutureOr<PassedHttpEntity> _wrapper(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
    Future Function() method,
  ) async {
    try {
      return await method();
    } on ServerException catch (e) {
      return SendResponse.sendBadBodyErrorToUser(response, e.message, e.code);
    } on AuthException catch (e) {
      return SendResponse.sendAuthErrorToUser(response, e.message, e.code);
    } on ServerLessException catch (e) {
      return SendResponse.sendOtherExceptionErrorToUser(
          response, e.message, e.code);
    } catch (e) {
      return SendResponse.sendUnknownError(response, null);
    }
  }

  @override
  FutureOr<PassedHttpEntity> login(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) {
    return _wrapper(
      request,
      response,
      pathArgs,
      () async {
        var data = await request.readAsJson();
        String emailKey = defaultAuthBodyKeys.email;
        String passwordKey = defaultAuthBodyKeys.password;
        String? email = data[emailKey];
        String? password = data[passwordKey];
        if (email == null || password == null) {
          throw RequestBodyError();
        }

        String jwt = await authService.loginWithEmail(
          email: email,
          password: password,
        );
        return SendResponse.sendDataToUser(response, jwt, dataFieldName: 'jwt');
      },
    );
  }

  @override
  FutureOr<PassedHttpEntity> register(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(
      request,
      response,
      pathArgs,
      () async {
        var data = await request.readAsJson();
        String emailKey = defaultAuthBodyKeys.email;
        String passwordKey = defaultAuthBodyKeys.password;
        String userDataKey = defaultAuthBodyKeys.userData;

        String? email = data[emailKey];
        String? password = data[passwordKey];
        Map<String, dynamic>? userData = data[userDataKey];

        if (email == null || password == null) {
          throw RequestBodyError();
        }

        String jwt = await authService.registerUser(
          email: email,
          password: password,
          userData: userData,
        );
        return SendResponse.sendDataToUser(response, jwt, dataFieldName: 'jwt');
      },
    );
  }

  @override
  AuthService authService;

  @override
  AuthBodyKeys defaultAuthBodyKeys;

  @override
  EmailVerificationProvider emailVerificationProvider;

  DefaultAuthServerHandlers(
    this.authService,
    this.defaultAuthBodyKeys,
    this.emailVerificationProvider,
  );

  @override
  FutureOr<PassedHttpEntity> getVerificationEmail(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  ) async {
    return _wrapper(request, response, pathArgs, () async {
      var body = await request.readAsJson();
      var userId = body[ModelFields.id];

      if (userId is! String) {
        throw RequestBodyError();
      }
      String token = await authService.createVerifyEmailToken(
        userId,
        allowNewJwtAfter: emailVerificationProvider.allowNewJwtAfter,
        verifyLinkExpiresAfter:
            emailVerificationProvider.verifyLinkExpiresAfter,
      );
      var payload = JWT
          .verify(
              token, authService.authDbProvider.app.authSettings.jwtSecretKey)
          .payload;
      String email = payload[ModelFields.email];
      // here i need to send that email to the user
      EmailService emailService = EmailService(authService.authDbProvider.app);
      Message message = getEmailVerificationMessage(
        mailTo: email,
        from: 'Dart Verse',
        subject: 'Test Email Verification',
      );
      await emailService.sendFromTemplateFile(
        message,
        'D:/Study And Work/Work/projects/flutter/Dart Mastery/dart_verse/templates/verification.html',
        {
          'name': email,
          'verify_link': token,
          'sender_name': 'Dart Verse',
        },
      );

      return SendResponse.sendDataToUser(
        response,
        'Email sent successfully',
        dataFieldName: 'msg',
      );
    });
  }
}

Message getEmailVerificationMessage({
  required String mailTo,
  required String from,
  String? subject,
}) {
  return Message()
    ..recipients.add(mailTo)
    ..bccRecipients.add(mailTo)
    ..subject = subject ?? 'Email Verification'
    ..from = from;
}
