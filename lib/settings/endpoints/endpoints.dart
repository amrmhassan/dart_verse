import 'package:dart_verse/settings/endpoints/repo/auth_endpoints.dart';
import 'package:dart_verse/settings/endpoints/impl/default_auth_endpoints.dart';

class EndpointsSettings {
  final AuthEndpoints authEndpoints;
  const EndpointsSettings({
    required this.authEndpoints,
  });
}

EndpointsSettings defaultEndpoints = EndpointsSettings(
  authEndpoints: DefaultAuthEndpoints(),
);
