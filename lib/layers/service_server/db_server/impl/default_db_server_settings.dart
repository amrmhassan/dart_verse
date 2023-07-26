import 'package:dart_verse/layers/service_server/db_server/impl/default_db_server_handlers.dart';
import 'package:dart_verse/layers/service_server/db_server/repo/db_server_handlers.dart';
import 'package:dart_verse/layers/service_server/db_server/repo/db_server_settings.dart';
import 'package:dart_verse/layers/services/db_manager/db_service.dart';
import 'package:dart_verse/layers/settings/app/app.dart';

class DefaultDbServerSettings implements DbServerSettings {
  @override
  late DbServerHandlers handlers;

  @override
  App app;

  @override
  DbService dbService;

  DefaultDbServerSettings(
    this.app,
    this.dbService, {
    DbServerHandlers? dbServerHandlers,
  }) {
    handlers = dbServerHandlers ??
        DefaultDbServerHandlers(
          app: app,
          dbService: dbService,
        );
  }
}
