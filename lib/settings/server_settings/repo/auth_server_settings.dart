import 'package:dart_verse/features/email_verification/repo/email_verification_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/web_server/repo/auth_middlewares.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_body_keys.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_handlers.dart';

abstract class AuthServerSettings {
  late AuthServerHandlers authServerHandlers;
  late AuthBodyKeys authBodyKeys;
  late AuthServerMiddlewares authServerMiddlewares;
  late EmailVerificationProvider emailVerificationProvider;

  late AuthService authService;
}
