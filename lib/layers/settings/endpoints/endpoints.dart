import 'package:dart_verse/layers/settings/endpoints/impl/default_storage_endpoints.dart';
import 'package:dart_verse/layers/settings/endpoints/repo/auth_endpoints.dart';
import 'package:dart_verse/layers/settings/endpoints/impl/default_auth_endpoints.dart';
import 'package:dart_verse/layers/settings/endpoints/repo/storage_endpoints.dart';

class EndpointsSettings {
  final AuthEndpoints authEndpoints;
  final StorageEndpoints storageEndpoints;

  const EndpointsSettings({
    required this.authEndpoints,
    required this.storageEndpoints,
  });
}

EndpointsSettings defaultEndpoints = EndpointsSettings(
  authEndpoints: DefaultAuthEndpoints(),
  storageEndpoints: DefaultStorageEndpoints(),
);
