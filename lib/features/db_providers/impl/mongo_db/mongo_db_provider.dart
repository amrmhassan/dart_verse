import 'package:dart_verse/settings/db_settings/repo/conn_link.dart';

import '../../repo/db_provider.dart';

class MongoDBProvider implements DBProvider {
  final MongoDbConnLink _connLink;
  const MongoDBProvider(this._connLink);
  MongoDbConnLink get connLink => _connLink;
}
