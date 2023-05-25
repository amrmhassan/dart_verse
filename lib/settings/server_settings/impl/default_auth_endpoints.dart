import 'package:dart_verse/settings/server_settings/repo/auth_endpoints.dart';

import '../../../constants/endpoints.dart';

class DefaultAuthEndpoints implements AuthEndpoints {
  @override
  String login = Endpoints.login;

  @override
  String register = Endpoints.register;
}
