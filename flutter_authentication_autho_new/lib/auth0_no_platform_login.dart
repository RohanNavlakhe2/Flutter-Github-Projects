

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutterdemo/ui_state_notifier.dart';
import 'package:flutterdemo/user_data.dart';

import 'base_login.dart';

class Auth0InvalidPlatformLogin implements Auth0Login{

  @override
  Future<void> auth0Login(){
     debugPrint("Invalid platform to login with auth0");
  }

  @override
  Stream<Response<UserData>> userStream;

  @override
  StreamSink<Response<UserData>> userStreamSink;

  @override
  StreamController<Response<UserData>> get userStreamController => throw UnimplementedError();

}

Auth0Login getAuth0Login() => Auth0InvalidPlatformLogin();