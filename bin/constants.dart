import 'package:dart_verse/serverless/settings/db_settings/impl/conn_link_impl.dart';
import 'package:dart_verse/serverless/settings/db_settings/repo/conn_link.dart';
import 'package:dotenv/dotenv.dart';

final env = DotEnv(includePlatformEnvironment: true)..load();

ConnLink cloudsConnLink = IpPortWithAuthConnLink(
  ip: env['DBIP'].toString(),
  port: int.parse(env['DBPORT'].toString()),
  dbName: 'admin',
  userName: env['DBUSERNAME'].toString(),
  password: env['DBPASSWORD'].toString(),
);
ConnLink atlasConnLink = DNSHostFullLink(
  connLink: env['REMOTECONNLINK'].toString(),
);
