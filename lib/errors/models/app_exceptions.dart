import 'package:dart_verse/errors/serverless_exception.dart';

class AppExceptions extends ServerLessException {
  String _message;

  AppExceptions(this._message);
  @override
  String get message => _message;

  @override
  set message(String value) => _message = value;
}

//? app exceptions
class NoDbSettingsExceptions extends AppExceptions {
  NoDbSettingsExceptions()
      : super('please provide DBSettings if you wanna use db');
}

class NoMongoDbProviderExceptions extends AppExceptions {
  NoMongoDbProviderExceptions()
      : super('no mongo db provider, please add one to db settings');
}

class NoMemoryDbProviderExceptions extends AppExceptions {
  NoMemoryDbProviderExceptions()
      : super('no memory db provider, please add one to db settings');
}

class NoAuthSettings extends AppExceptions {
  NoAuthSettings() : super('please provider authSettings to the app');
}
