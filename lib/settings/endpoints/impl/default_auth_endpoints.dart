import '../../../constants/endpoints_constants.dart';
import '../repo/auth_endpoints.dart';

class DefaultAuthEndpoints implements AuthEndpoints {
  @override
  String login = EndpointsConstants.login;

  @override
  String register = EndpointsConstants.register;
  @override
  String verifyEmail = EndpointsConstants.verifyEmail;
  @override
  String getVerificationEmail = EndpointsConstants.getVerificationEmail;
}
