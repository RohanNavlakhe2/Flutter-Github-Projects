import 'dart:html';

import 'package:autho_web/auth_client/client_interface.dart';
import 'package:flutter_appauth_platform_interface/flutter_appauth_platform_interface.dart';
import 'package:flutter_appauth_web/flutter_appauth_web.dart';

class B2CAuthWeb implements B2CAuth {
  /// Azure AD B2C Attributes (AppAuth Web And Mobile Demo)

  final domain = 'dev-pxsj205r.us.auth0.com';
  final discoveryUrl = 'https://xxx.b2clogin.com/xxx.onmicrosoft.com/v2.0/.well-known/openid-configuration?p=B2C_1_xxx';
  final issuer = 'https://xxx.b2clogin.com/xxxxxxxxxxxx/v2.0/';

  /*final clientId = 'xxxxxxxx';*/
  final clientId = 'CDjPTBAvnaZ5c5e9hrfBBjB8lnl58bQE';
  final redirectUrl = 'http://localhost:60664/callback.html';
  final policyNameSignIn = 'B2C_1_xxx';
  final additionalParameters = null;
  final List<String> scopes = ['openid', 'profile'];

  @override
  Future<AuthorizationTokenResponse> processStartup() async {
    AppAuthWebPlugin _appAuth = AppAuthWebPlugin();
    print("Running b2c web startup process...");
    print("Session storage: " + window.sessionStorage.toString());

    /*AuthorizationTokenRequest _request = AuthorizationTokenRequest(
      clientId,
      redirectUrl,
      discoveryUrl: discoveryUrl,
      scopes: scopes,
      promptValues: ['login'],
      serviceConfiguration: AuthorizationServiceConfiguration(
        "https://xxx.b2clogin.com/xxx.onmicrosoft.com/$policyNameSignIn/oauth2/v2.0/authorize",
        "https://xxx.b2clogin.com/xxx.onmicrosoft.com/$policyNameSignIn/oauth2/v2.0/token",
      ),
      additionalParameters: additionalParameters,
      issuer: issuer,
    );*/



    AuthorizationTokenRequest _request = AuthorizationTokenRequest(clientId, redirectUrl, issuer: 'https://$domain', scopes: <String>['openid', 'profile', 'offline_access']);

    try {
      AuthorizationTokenResponse _authTokenResponse = await AppAuthWebPlugin.processStartup(_request);

      print("Startup response: " + _authTokenResponse.toString());
      return _authTokenResponse;
    } catch (e, s) {
      print("B2C Process Startup Error.");
      print(e);
      print(s);
      return null;
    }
  }

  @override
  void signIn() async {
    AppAuthWebPlugin _appAuth = AppAuthWebPlugin();
    print("Starting authentication on WEB");

    try {
      /*final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          promptValues: ['login'],
          serviceConfiguration: AuthorizationServiceConfiguration(
            "https://xxx.b2clogin.com/xxx.onmicrosoft.com/$policyNameSignIn/oauth2/v2.0/authorize",
            "https://xxx.b2clogin.com/xxx.onmicrosoft.com/$policyNameSignIn/oauth2/v2.0/token",
          ),
          scopes: scopes,
        ),
      );*/


      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          redirectUrl,
          issuer: 'https://$domain',
          scopes: <String>['openid', 'profile', 'offline_access'],
            promptValues: ['login'],

        ),
      );

      if(result == null)
        print("web login result null");
      else
        print("web login result token: ${result.accessToken}");

      //print("AppAuth Sign In Response ID Token: " + result.idToken);
    } catch (e, s) {
      print("B2C Web Sign In Error");
      print(e);
      print(s);
    }
  }
}

B2CAuth getB2CAuthImplementation() => B2CAuthWeb();
