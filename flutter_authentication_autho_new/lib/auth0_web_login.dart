import 'dart:async';

import 'package:auth0_flutter_web/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterdemo/ui_state_notifier.dart';
import 'package:flutterdemo/user_data.dart';
import 'base_login.dart';

class Auth0WebLogin implements Auth0Login{

  @override
  Future<void> auth0Login() async {

    debugPrint('Login in web');
    try{

      final Auth0 auth0 = await createAuth0Client(Auth0CreateOptions(
        domain: Auth0Login.AUTH0_DOMAIN,
        client_id: Auth0Login.AUTH0_CLIENT_ID,
      ));

      await auth0.loginWithPopup();
      Map<String, dynamic> user = await auth0.getUser();
      Map<String, dynamic> idToken = await auth0.getIdTokenClaims(options: GetIdTokenClaimsOptions(scope: "email"));
      debugPrint("User Data: $user");
      debugPrint("Id token : ${idToken['__raw']}");
      UserData userData = UserData(user['name'],user['picture']);

      userStreamSink.add(Response.completed(userData));
      /* setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = user['name'];
        picture = user['picture'];
      });*/
    }on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      /* setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });*/
    }


  }

  @override
  Stream<Response<UserData>> userStream;

  @override
  StreamSink<Response<UserData>> userStreamSink;

  @override
  StreamController<Response<UserData>> userStreamController;

  Auth0WebLogin(){
    userStreamController = StreamController.broadcast();
    userStreamSink = userStreamController.sink;
    userStream = userStreamController.stream;
  }
}

Auth0Login getAuth0Login() => Auth0WebLogin();