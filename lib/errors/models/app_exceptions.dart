import 'package:dart_verse/errors/serverless_exception.dart';

class AppExceptions implements ServerLessException {
  @override
  String message;
  AppExceptions(this.message);
}

//? app exceptions
class NoDbSettingsExceptions implements AppExceptions {
  @override
  String message = 'please provide DBSettings if you wanna use db';
}

class NoMongoDbProviderExceptions implements AppExceptions {
  @override
  String message = 'no mongo db provider, please add one to db settings';
}

class NoMemoryDbProviderExceptions implements AppExceptions {
  @override
  String message = 'no memory db provider, please add one to db settings';
}

class NoAuthSettings implements AppExceptions {
  @override
  String message = 'please provider authSettings to the app';
}
