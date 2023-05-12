import 'package:dotenv/dotenv.dart';

class DbConst {
  // the command to run on the server to listen run mongod server
  //? sudo mongod --port 7000 --dbpath /var/lib/mongodb --bind_ip 0.0.0.0 --noauth

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
