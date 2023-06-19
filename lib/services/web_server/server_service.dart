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

  Future<HttpServer> runServer() async {
    InternetAddress ip = _app.serverSettings.ip;
    int port = _app.serverSettings.port;
    _addAuthEndpoints();
    ServerHolder serverHolder = ServerHolder(_cascade);
    var server = await serverHolder.bind(ip, port);
    return server;
  }

  //! data in this like idFieldName and role and their values will be checked from the jwt payload
  //! try to combine the addRouter and addPipeline
  // ServerService addPipeline(
  //   Pipeline pipeline, {
  //   bool jwtSecured = false,
  //   String? idFieldName,
  //   String? idEqualTo,
  //   String? roleFieldName,
  //   String? roleEqualTo,
  // }) {
  //   //? adding middlewares here
  //   if (jwtSecured) {
  //     pipeline
  //         .addUpperMiddleware(
  //           null,
  //           HttpMethods.all,
  //           authServerSettings.authServerMiddlewares.checkJwtInHeaders,
  //         )
  //         .addUpperMiddleware(
  //           null,
  //           HttpMethods.all,
  //           authServerSettings.authServerMiddlewares.checkJwtForUserId,
  //         );
  //   }

  //   //?

  //   _cascade = _cascade.add(pipeline);
  //   return this;
  // }

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
  }) {
    //? adding middlewares here
    if (jwtSecured) {
      router
          .addUpperMiddleware(
            null,
            HttpMethods.all,
            authServerSettings.authServerMiddlewares.checkAppId,
          )
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
    String loginPath = authServerSettings.authEndpoints.login;
    String registerPath = authServerSettings.authEndpoints.register;
    String getVerificationEmail =
        authServerSettings.authEndpoints.getVerificationEmail;
    String verifyEmail = authServerSettings.authEndpoints.verifyEmail;
    // String jwtLoginPath = authEndpoints.jwtLogin;

    // adding auth endpoints pipeline
    var authRouter = Router()
      ..get(
        '$verifyEmail/<${PathFields.jwt}>',
        authServerSettings.authServerHandlers.verifyEmail,
      )
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
        getVerificationEmail,
        (request, response, pathArgs) =>
            authServerSettings.authServerHandlers.getVerificationEmail(
          request,
          response,
          pathArgs,
          'http://localhost:3000$verifyEmail/',
        ),
      );

    addRouter(authRouter);
  }
}
