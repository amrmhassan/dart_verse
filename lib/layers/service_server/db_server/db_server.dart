import 'package:dart_verse/layers/service_server/service_server.dart';
import 'package:dart_webcore/dart_webcore/routing/impl/router.dart';

class DBServer implements ServiceServerLayer {
  @override
  Router getRouter() {
    Router router = Router();
    return router;
  }
}
