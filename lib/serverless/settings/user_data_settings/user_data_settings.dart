import 'package:auth_server/serverless/constants/collections.dart';

class UserDataSettings {
  final String collectionName;
  const UserDataSettings({
    this.collectionName = DBCollections.users,
  });
}
