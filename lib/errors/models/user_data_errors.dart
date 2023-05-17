// ignore_for_file: overridden_fields

import 'package:dart_verse/errors/serverless_exception.dart';

abstract class UserDataExceptions extends ServerLessException {
  @override
  String message;

  UserDataExceptions(this.message);
}

class NoUserDataSettingsException extends UserDataExceptions {
  NoUserDataSettingsException()
      : super(
            'no user data settings provided, please add UserDataSettings to the app');
}
