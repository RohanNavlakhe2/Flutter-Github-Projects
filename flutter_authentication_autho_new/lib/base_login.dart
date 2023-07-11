import 'dart:async';

import 'package:flutterdemo/ui_state_notifier.dart';
import 'package:flutterdemo/user_data.dart';

import 'auth0_no_platform_login.dart'
   if(dart.library.io) 'auth0_native_login.dart'
   if(dart.library.html) 'auth0_web_login.dart';



abstract class Auth0Login{

  static const String AUTH0_DOMAIN = 'dev-pxsj205r.us.auth0.com';
  static const String AUTH0_CLIENT_ID = 'CDjPTBAvnaZ5c5e9hrfBBjB8lnl58bQE';
  static const String AUTH0_REDIRECT_URI = 'com.auth0.flutterdemo://login-callback';
  static const String AUTH0_ISSUER = 'https://$AUTH0_DOMAIN';

  final StreamController<Response<UserData>> userStreamController;
  StreamSink<Response<UserData>> userStreamSink ;
  Stream<Response<UserData>> userStream ;



  Future<void> auth0Login(){}

  factory Auth0Login() => getAuth0Login();
}

