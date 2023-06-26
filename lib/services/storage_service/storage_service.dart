import 'package:dart_verse/services/web_server/server_service.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_verse/settings/storage_settings/impl/default_storage_server_handlers.dart';
import 'package:dart_verse/settings/storage_settings/repo/storage_server_handlers.dart';
import 'package:dart_webcore/dart_webcore.dart';

class StorageService {
  final App _app;
  final ServerService _serverService;
  late StorageServerHandlers _serverHandlers;
  StorageService(
    this._app,
    this._serverService, {
    StorageServerHandlers? storageServerHandlers,
  }) {
    _serverHandlers = storageServerHandlers ??
        DefaultStorageServerHandlers(
          app: _app,
        );
    _addEndpoints();
  }
  // here i want to allowed adding files from http request by getting the file from the request then saving it here on the server
  // and providing a link for getting the percentage done from the file operation and that link will be for a ws server

  void _addEndpoints({
    bool jwtSecured = true,
    bool emailMustBeVerified = true,
    bool appIdSecured = true,
  }) {
    // paths
    String upload = _app.endpoints.storageEndpoints.upload;
    String download = _app.endpoints.storageEndpoints.download;
    String delete = _app.endpoints.storageEndpoints.delete;
    // handlers
    var router = Router()
      ..post(upload, _serverHandlers.upload)
      ..get(download, _serverHandlers.download)
      ..delete(delete, _serverHandlers.delete);
    _serverService.addRouter(
      router,
      appIdSecured: appIdSecured,
      emailMustBeVerified: emailMustBeVerified,
      jwtSecured: jwtSecured,
    );
  }
}
