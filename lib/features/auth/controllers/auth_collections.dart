import 'package:dart_verse/settings/app/app.dart';
import 'package:mongo_dart/mongo_dart.dart';

class AuthCollections {
  final App _app;
  const AuthCollections(this._app);
  DbCollection get auth => DbCollection(
        _app.getDB,
        _app.authSettings.collectionName,
      );

  DbCollection get activeJWTs => DbCollection(
        _app.getDB,
        _app.authSettings.activeJWTCollName,
      );
  DbCollection get usersData => DbCollection(
        _app.getDB,
        _app.userDataSettings.collectionName,
      );
}
