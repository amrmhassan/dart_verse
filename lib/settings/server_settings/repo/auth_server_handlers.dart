import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_body_keys.dart';
import 'package:shelf/shelf.dart';

import '../../../features/email_verification/repo/email_verification_provider.dart';

abstract class AuthServerHandlers {
  late AuthService authService;
  late AuthBodyKeys defaultAuthBodyKeys;
  late EmailVerificationProvider emailVerificationProvider;

  Function register(Request request);
  Function login(Request request);
  Function getVerificationEmail(Request request);
}
