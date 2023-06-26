import 'package:dart_verse/features/email_verification/impl/default_email_verification_provider.dart';
import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/web_server/repo/auth_middlewares.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_body_keys.dart';
// import 'package:dart_verse/settings/server_settings/impl/default_auth_endpoints.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_server_handlers.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_body_keys.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_handlers.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_settings.dart';

import '../../../features/email_verification/repo/email_verification_provider.dart';
import '../../../services/web_server/impl/default_auth_middlewares.dart';
import '../../endpoints/repo/auth_endpoints.dart';

class DefaultAuthServerSettings implements AuthServerSettings {
  // @override
  // late AuthEndpoints authEndpoints;

  @override
  late AuthServerHandlers authServerHandlers;
  @override
  late AuthBodyKeys authBodyKeys;

  @override
  late AuthService authService;

  @override
  late AuthServerMiddlewares authServerMiddlewares;

  @override
  late EmailVerificationProvider emailVerificationProvider;

  DefaultAuthServerSettings(
    this.authService, {
    AuthBodyKeys? cAuthBodyKeys,
    AuthServerHandlers? cAuthServerHandlers,
    AuthEndpoints? cAuthEndpoints,
    AuthServerMiddlewares? cAuthServerMiddlewares,
    EmailVerificationProvider? cEmailVerificationProvider,
    String? cBackendHost,
  }) {
    authBodyKeys = cAuthBodyKeys ?? DefaultAuthBodyKeys();
    authServerMiddlewares =
        cAuthServerMiddlewares ?? DefaultAuthMiddlewares(authService);
    emailVerificationProvider = cEmailVerificationProvider ??
        DefaultEmailVerificationProvider(
          authService: authService,
        );

    authServerHandlers = cAuthServerHandlers ??
        DefaultAuthServerHandlers(
          authService,
          authBodyKeys,
          emailVerificationProvider,
        );
  }
}
