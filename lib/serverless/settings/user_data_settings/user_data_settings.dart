import 'package:dart_verse/serverless/constants/collections.dart';

class UserDataSettings {
  final String collectionName;
  const UserDataSettings({
    this.collectionName = DBCollections.users,
  });
}
