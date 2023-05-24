import 'dart:io';

class ServerSettings {
  final InternetAddress ip;
  final int port;

  const ServerSettings(
    this.ip,
    this.port,
  );
}
