import 'dart:io';

import 'package:dart_verse/settings/server_settings/repo/auth_server_settings.dart';

import '../../errors/models/server_errors.dart';

class ServerSettings {
  final InternetAddress ip;
  final int port;
  final AuthServerSettings? _authServerSettings;

  ServerSettings(
    this.ip,
    this.port, {
    AuthServerSettings? authServerSettings,
  }) : _authServerSettings = authServerSettings;
  AuthServerSettings get authServerSettings {
    if (_authServerSettings == null) {
      throw NoAuthServerSettingsException();
    }
    return _authServerSettings!;
  }

  AuthServerSettings? get nullableAuthServerSettings {
    return _authServerSettings;
  }
}
