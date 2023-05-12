import 'dart:io';

import 'package:auth_server/constants/app_const.dart';
import 'package:auth_server/constants/db_const.dart';
import 'package:auth_server/features/app/router/router.dart';
import 'package:auth_server/helpers/router_system/server.dart';
import 'package:mongo_dart/mongo_dart.dart';

App app = App();

class App {
  late Db db;
  Future<void> init() async {
    bool dbRes = await _connDb();
    if (!dbRes) return;

    await _openServer();
  }

  Future<bool> _openServer() async {
    try {
      var server = await CustomServer(
        Router().router,
        InternetAddress.anyIPv4,
        AppConst.port,
      ).bind();
      print('listening on ${server.port}');

      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> _connDb() async {
    try {
      print('trying to connect to db...');
      String uri = DbConst().connectionUri();
      db = Db(uri);
      await db.open();
      print('connected to db.');

      return true;
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
