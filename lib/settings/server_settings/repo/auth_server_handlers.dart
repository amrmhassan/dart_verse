import 'dart:async';

import 'package:dart_express/dart_express.dart';
import 'package:dart_express/dart_express/server/repo/passed_http_entity.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_body_keys.dart';

import '../../../features/email_verification/repo/email_verification_provider.dart';

abstract class AuthServerHandlers {
  late AuthService authService;
  late AuthBodyKeys defaultAuthBodyKeys;
  late EmailVerificationProvider emailVerificationProvider;

  FutureOr<PassedHttpEntity> register(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
  FutureOr<PassedHttpEntity> login(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
  FutureOr<PassedHttpEntity> getVerificationEmail(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
}
