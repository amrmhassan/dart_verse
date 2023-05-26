import 'dart:async';

import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:shelf/shelf.dart';

abstract class AuthServerMiddlewares {
  late AuthService authService;
  late App app;

  FutureOr<Response> Function(Request request) checkJwtInHeaders(
      FutureOr<Response> Function(Request request) innerHandler);

  // FutureOr<Response> Function(Request request) checkJwtValid(
  //     FutureOr<Response> Function(Request request) innerHandler);

  FutureOr<Response> Function(Request request) checkJwtForUserId(
      FutureOr<Response> Function(Request request) innerHandler);
}
