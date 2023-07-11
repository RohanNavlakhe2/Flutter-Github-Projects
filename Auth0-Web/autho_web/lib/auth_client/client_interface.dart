import 'package:autho_web/src/client_web.dart';
import 'package:flutter_appauth_platform_interface/flutter_appauth_platform_interface.dart';


/*if (dart.library.io) './src/client_mobile.dart' // dart:io implementation
if (dart.library.html) './src/client_web.dart';*/ // dart:html implementation

abstract class B2CAuth {
  // Process startup
  Future<AuthorizationTokenResponse> processStartup() {}

  // Sign In Function
  void signIn() {}

  // Return the correct implementation
  factory B2CAuth() => getB2CAuthImplementation();
}