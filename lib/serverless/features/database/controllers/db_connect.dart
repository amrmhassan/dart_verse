import 'package:auth_server/serverless/settings/db_settings/repo/conn_link.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DbConnect {
  final ConnLink _connLink;
  const DbConnect(this._connLink);

  Future<Db> connect() async {
    late Db db;
    String uri = _connLink.getConnLink;

    print('trying to connect to db...');

    if (_connLink is DNSConnLink) {
      db = await _dnsConnect(uri);
    } else {
      db = await _normalConnect(uri);
    }

    print('connected to db.');

    return db;
  }

  Future<Db> _dnsConnect(String uri) async {
    Db db = await Db.create(uri);
    await db.open();
    return db;
  }

  Future<Db> _normalConnect(String uri) async {
    Db db = Db(uri);
    await db.open();
    return db;
  }
}
