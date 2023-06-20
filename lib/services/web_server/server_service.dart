import 'dart:async';
import 'dart:io';

import 'package:dart_verse/constants/path_fields.dart';
import 'package:dart_verse/settings/app/app.dart';
import 'package:dart_webcore/dart_webcore.dart';

import '../../errors/models/server_errors.dart';
import '../../settings/server_settings/repo/auth_server_settings.dart';

class ServerService {
  final App _app;
  final AuthServerSettings? _authServerSettings;

  ServerService(
    this._app, {
    AuthServerSettings? authServerSettings,
  }) : _authServerSettings = authServerSettings {
    _cascade = Cascade();
  }

  late Cascade _cascade;

  Future<HttpServer> runServer({
    bool log = false,
  }) async {
    InternetAddress ip = _app.serverSettings.ip;
    int port = _app.serverSettings.port;
    _addAuthEndpoints();
    ServerHolder serverHolder = ServerHolder(_cascade);
    serverHolder.addGlobalMiddleware(logRequest);
    var server = await serverHolder.bind(ip, port);
    return server;
  }

  //! data in this like idFieldName and role and their values will be checked from the jwt payload
  //! try to combine the addRouter and addPipeline
  //! i want to create use it like this
  /*
              the addRouter method should be provided with the place of the provided user id
              whether it should be in body or as authorization in headers bearer
              and the user id key name where it will be '_id' or 'id' or whatever
              addRouter(put parameters here).secure(bool userAuth = true, bool userData = false,(map allUserDataWillBeHere(Auth And User Data)){
                if userAuth is true the map allUserDataWillBeHere will contain userAuth, and the same for userData
                return bool;
              })

              and the add Router method should return a secure object or SecureHandler Object
              this secure handler class i don't know yet what to add in it but 
              */
  ServerService addRouter(
    Router router, {
    bool jwtSecured = false,
    bool emailMustBeVerified = false,
    bool appIdSecured = true,
  }) {
    //? run checks here
    if (!jwtSecured && emailMustBeVerified) {
      throw Exception(
          'emailMustBeVerified && !jwtSecured, to check if email must be verified user must be logged in first');
    }

    //? adding middlewares here
    // checking for app id for every
    if (appIdSecured) {
      router.addUpperMiddleware(
        null,
        HttpMethods.all,
        authServerSettings.authServerMiddlewares.checkAppId,
      );
    }
    // checking if jwt is added and user logged in
    if (jwtSecured) {
      router
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkJwtInHeaders,
            signature: 'checkJwtInHeaders',
          )
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkJwtForUserId,
            signature: 'checkJwtForUserId',
          );
    }
    // checking if email is verified
    if (emailMustBeVerified) {
      router.addUpperMiddleware(
        null,
        HttpMethods.all,
        authServerSettings.authServerMiddlewares.checkUserEmailVerified,
      );
    }
    Pipeline pipeline = Pipeline().addRouter(router);

    //?

    _cascade = _cascade.add(pipeline);
    return this;
  }

  Cascade get cascade {
    return _cascade;
  }

  AuthServerSettings get authServerSettings {
    if (_authServerSettings == null) {
      throw NoAuthServerSettingsException();
    }
    return _authServerSettings!;
  }

  void _addAuthEndpoints() {
    if (_authServerSettings == null) return;
    // endpoints
    String loginPath = _app.endpoints.authEndpoints.login;
    String registerPath = _app.endpoints.authEndpoints.register;
    String getVerificationEmail =
        _app.endpoints.authEndpoints.getVerificationEmail;
    String verifyEmail = _app.endpoints.authEndpoints.verifyEmail;
    String changePassword = _app.endpoints.authEndpoints.changePassword;
    // String forgetPassword = _app.endpoints.authEndpoints.forgetPassword;

    // other needed data
    int port = _app.serverSettings.port;
    String host = authServerSettings.backendHost;

    // adding auth endpoints pipeline
    var authRouter = Router()
      //? won't check for app id here (can be used from a browser)
      ..get(
        '$verifyEmail/<${PathFields.jwt}>',
        authServerSettings.authServerHandlers.verifyEmail,
      )
      //? will check for app id from here
      ..addRouterMiddleware(
        authServerSettings.authServerMiddlewares.checkAppId,
      )
      ..post(
        loginPath,
        authServerSettings.authServerHandlers.login,
      )
      ..post(
        registerPath,
        authServerSettings.authServerHandlers.register,
      )
      ..post(
        changePassword,
        authServerSettings.authServerHandlers.changePassword,
      )
      //? will check for jwt from here
      ..addRouterMiddleware(
        authServerSettings.authServerMiddlewares.checkJwtInHeaders,
        signature: 'checkJwtInHeaders',
      )
      ..addRouterMiddleware(
        authServerSettings.authServerMiddlewares.checkJwtForUserId,
        signature: 'checkJwtForUserId',
      )
      ..post(
        getVerificationEmail,
        (request, response, pathArgs) =>
            authServerSettings.authServerHandlers.getVerificationEmail(
          request,
          response,
          pathArgs,
          // i need the host here and the port
          '$host:$port$verifyEmail/',
        ),
      );

    addRouter(authRouter);
  }
}
