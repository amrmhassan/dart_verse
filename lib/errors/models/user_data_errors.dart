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

class UserDataServiceDependOnAuthServiceException extends UserDataExceptions {
  UserDataServiceDependOnAuthServiceException()
      : super(
            'the _authService.authDbProvider in userDataService does\'nt match any of the userDataServiceDbProviders, please check your userDataDbProviders');
}
