import 'dart:io';
import 'package:autho_web/auth_client/client_interface.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class B2CAuthMobile implements B2CAuth {
  /// Azure AD B2C Attributes (AppAuth Web And Mobile Demo)
  final clientId = 'xxxxxxxxxxxxxx';
  final redirectUrl = 'xxx.xxx.xxxxxxx://oauthredirect/';
  final policyNameSignIn = 'B2C_1_xxxxx';
  final List<String> scopes = ['openid', 'profile', 'offline_access', 'client_id_here'];

  @override
  Future<AuthorizationTokenResponse> processStartup() async{

  }

  @override
  void signIn() async {
    FlutterAppAuth _appAuth = FlutterAppAuth();
    print("Starting authentication on MOBILE");

    try {
      final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId, redirectUrl,
          promptValues: ['login'],
          serviceConfiguration: AuthorizationServiceConfiguration(
            "https://xxx.b2clogin.com/xxx.onmicrosoft.com/$policyNameSignIn/oauth2/v2.0/authorize",
            "https://xxx.b2clogin.com/xxx.onmicrosoft.com/$policyNameSignIn/oauth2/v2.0/token",
          ),
          scopes: scopes,
          preferEphemeralSession: Platform.isIOS, // iOS requires this to support the private browser (iOS 13 and newer)
        ),
      );

      print("AppAuth Sign In Response ID Token: " + result.idToken);
    } catch (e) {
      print(e.toString());
    }
  }
}

B2CAuth getB2CAuthImplementation() => B2CAuthMobile();