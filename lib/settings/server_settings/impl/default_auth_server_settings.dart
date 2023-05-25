import 'package:dart_verse/services/auth/auth_service.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_body_keys.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_endpoints.dart';
import 'package:dart_verse/settings/server_settings/impl/default_auth_server_handlers.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_body_keys.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_handlers.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_endpoints.dart';
import 'package:dart_verse/settings/server_settings/repo/auth_server_settings.dart';

class DefaultAuthServerSettings implements AuthServerSettings {
  @override
  late AuthEndpoints authEndpoints;

  @override
  late AuthServerHandlers authServerHandlers;
  @override
  late AuthBodyKeys authBodyKeys;

  @override
  late AuthService authService;
  DefaultAuthServerSettings(
    this.authService, {
    AuthBodyKeys? cAuthBodyKeys,
    AuthServerHandlers? cAuthServerHandlers,
    AuthEndpoints? cAuthEndpoints,
  }) {
    authBodyKeys = cAuthBodyKeys ?? DefaultAuthBodyKeys();
    authServerHandlers = cAuthServerHandlers ??
        DefaultAuthServerHandlers(authService, authBodyKeys);
    authEndpoints = cAuthEndpoints ?? DefaultAuthEndpoints();
  }
}
