import 'package:auth_server/serverless/constants/collections.dart';

class AuthSettings {
  //
  final String collectionName;
  const AuthSettings({
    this.collectionName = DBCollections.auth,
  });
}
