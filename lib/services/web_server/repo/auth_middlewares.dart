import 'dart:async';

import 'package:dart_express/dart_express.dart';
import 'package:dart_express/dart_express/server/repo/passed_http_entity.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/app/app.dart';

abstract class AuthServerMiddlewares {
  late AuthService authService;
  late App app;

  FutureOr<PassedHttpEntity> checkJwtInHeaders(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
  FutureOr<PassedHttpEntity> checkJwtForUserId(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
  FutureOr<PassedHttpEntity> checkAppId(
    RequestHolder request,
    ResponseHolder response,
    Map<String, dynamic> pathArgs,
  );
}
