import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutterdemo/ui_state_notifier.dart';
import 'package:flutterdemo/user_data.dart';
import 'package:http/http.dart' as http;

import 'base_login.dart';


class Auth0NativeLogin implements Auth0Login {

  final FlutterAppAuth appAuth = FlutterAppAuth();

  Future<void> auth0Login() async {
/* setState(() {
      isBusy = true;
      errorMessage = '';
    });*/

    try {
      final AuthorizationTokenResponse result = await appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Auth0Login.AUTH0_CLIENT_ID,
          Auth0Login.AUTH0_REDIRECT_URI,
          issuer: 'https://${Auth0Login.AUTH0_DOMAIN}',
          scopes: <String>['openid', 'profile', 'offline_access'],
          // promptValues: ['login']
        ),
      );

      // ignore: lines_longer_than_80_chars
      final Map<String, Object> idToken = parseIdToken(result.idToken);
      final Map<String, Object> profile = await getUserDetails(result.accessToken);

      debugPrint('Id token : ${result.idToken}');
      debugPrint("Profile : ${profile}");
      UserData userData = UserData(idToken['name'],profile['picture']);

      userStreamSink.add(Response.completed(userData));

      /* await secureStorage.write(key: 'refresh_token', value: result.refreshToken);*/

      /*setState(() {
        isBusy = false;
        isLoggedIn = true;
        name = idToken['name'];
        picture = profile['picture'];
      });*/
    } on Exception catch (e, s) {
      debugPrint('login error: $e - stack: $s');

      /*setState(() {
        isBusy = false;
        isLoggedIn = false;
        errorMessage = e.toString();
      });*/
    }
  }

  Map<String, Object> parseIdToken(String idToken) {
    final List<String> parts = idToken.split('.');
    // ignore: lines_longer_than_80_chars
    assert(parts.length == 3);


    return jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))));
  }

  Future<Map<String, Object>> getUserDetails(String accessToken) async {
    const String url = 'https://${Auth0Login.AUTH0_DOMAIN}/userinfo';
    final http.Response response = await http.get(
      url,
      headers: <String, String>{'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user details');
    }
  }

  @override
  Stream<Response<UserData>> userStream;

  @override
  StreamSink<Response<UserData>> userStreamSink;

  @override
  StreamController<Response<UserData>> userStreamController;

  Auth0NativeLogin(){
    userStreamController = StreamController.broadcast();
    userStreamSink = userStreamController.sink;
    userStream = userStreamController.stream;
  }


}

Auth0Login getAuth0Login() => Auth0NativeLogin();