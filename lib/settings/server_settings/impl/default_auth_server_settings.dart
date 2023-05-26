import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/services/web_server/repo/auth_middlewares.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_body_keys.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_endpoints.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_server_handlers.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_body_keys.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_handlers.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_endpoints.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_settings.dart';

import '../../../services/web_server/impl/default_auth_middlewares.dart';

class DefaultAuthServerSettings implements AuthServerSettings {
  @override
  late AuthEndpoints authEndpoints;

  @override
  late AuthServerHandlers authServerHandlers;
  @override
  late AuthBodyKeys authBodyKeys;

  @override
  late AuthService authService;
  @override
  late App app;

  @override
  late AuthServerMiddlewares authServerMiddlewares;

  DefaultAuthServerSettings(
    this.app,
    this.authService, {
    AuthBodyKeys? cAuthBodyKeys,
    AuthServerHandlers? cAuthServerHandlers,
    AuthEndpoints? cAuthEndpoints,
    AuthServerMiddlewares? cAuthServerMiddlewares,
  }) {
    authBodyKeys = cAuthBodyKeys ?? DefaultAuthBodyKeys();
    authServerHandlers = cAuthServerHandlers ??
        DefaultAuthServerHandlers(authService, authBodyKeys);
    authEndpoints = cAuthEndpoints ?? DefaultAuthEndpoints();

    authServerMiddlewares =
        cAuthServerMiddlewares ?? DefaultAuthMiddlewares(authService, app);
  }
}
