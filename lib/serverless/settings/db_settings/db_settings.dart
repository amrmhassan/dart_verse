import 'package:auth_server/serverless/settings/db_settings/repo/conn_link.dart';

class DBSettings {
  final ConnLink _connLink;
  const DBSettings({
    required ConnLink connLink,
  }) : _connLink = connLink;
  ConnLink get connLink => _connLink;
}
