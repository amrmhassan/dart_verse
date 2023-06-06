import 'package:dart_express/dart_express.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/app/app.dart';

abstract class AuthServerMiddlewares {
  late AuthService authService;
  late App app;

  late Middleware checkJwtInHeaders;

  late Middleware checkJwtForUserId;
}
