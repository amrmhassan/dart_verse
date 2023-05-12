import 'package:dotenv/dotenv.dart';

class DbAuth {
  final String _dbName = 'admin';
  final _env = DotEnv(includePlatformEnvironment: true)..load();

  String connectionUri({
    String? username,
    String? password,
    String? ip,
    int? port,
    int? dbName,
  }) {
    return 'mongodb://${username ?? _env['DBUSERNAME']}:${password ?? _env['DBPASSWORD']}@${ip ?? _env['DBIP']}:${port ?? _env['DBPORT']}/${dbName ?? _dbName}';
  }
}
