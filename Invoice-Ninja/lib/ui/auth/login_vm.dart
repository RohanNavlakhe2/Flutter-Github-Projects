import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/dashboard/dashboard_actions.dart';
import 'package:invoiceninja_flutter/redux/ui/pref_state.dart';
import 'package:invoiceninja_flutter/ui/app/app_builder.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';
import 'package:invoiceninja_flutter/utils/oauth.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/redux/auth/auth_actions.dart';
import 'package:invoiceninja_flutter/ui/auth/login_view.dart';
import 'package:invoiceninja_flutter/redux/auth/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  static const String route = '/login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, LoginVM>(
        converter: LoginVM.fromStore,
        builder: (context, viewModel) {
          return LoginView(
            viewModel: viewModel,
          );
        },
      ),
    );
  }
}

class LoginVM {
  LoginVM({
    @required this.state,
    @required this.isLoading,
    @required this.authState,
    @required this.onLoginPressed,
    @required this.onRecoverPressed,
    @required this.onSignUpPressed,
    @required this.onGoogleLoginPressed,
    @required this.onGoogleSignUpPressed,
  });

  AppState state;
  bool isLoading;
  AuthState authState;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    @required String email,
    @required String password,
    @required String url,
    @required String secret,
    @required String oneTimePassword,
  }) onLoginPressed;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    @required String email,
    @required String url,
    @required String secret,
  }) onRecoverPressed;

  final Function(
    BuildContext,
    Completer<Null> completer, {
    @required String email,
    @required String password,
  }) onSignUpPressed;

  final Function(BuildContext, Completer<Null> completer,
      {String url, String secret, String oneTimePassword}) onGoogleLoginPressed;
  final Function(BuildContext, Completer<Null> completer) onGoogleSignUpPressed;

  static LoginVM fromStore(Store<AppState> store) {
    void _handleLogin({BuildContext context, bool isSignUp = false}) {
      final layout = calculateLayout(context);

      store.dispatch(UpdateUserPreferences(appLayout: layout));
      AppBuilder.of(context).rebuild();

      WidgetsBinding.instance.addPostFrameCallback((duration) {
        if (layout == AppLayout.mobile) {
          if (isSignUp) {
            store.dispatch(
                UpdateUserPreferences(moduleLayout: ModuleLayout.list));
          }
          store.dispatch(ViewDashboard(navigator: Navigator.of(context)));
        } else {
          store.dispatch(ViewMainScreen(navigator: Navigator.of(context)));
        }
      });
    }

    return LoginVM(
        state: store.state,
        isLoading: store.state.isLoading,
        authState: store.state.authState,
        onGoogleLoginPressed: (
          BuildContext context,
          Completer<Null> completer, {
          @required String url,
          @required String secret,
          @required String oneTimePassword,
        }) async {
          try {
            googleSignIn((idToken, accessToken, serverAuthCode) {
              store.dispatch(OAuthLoginRequest(
                completer: completer,
                idToken: idToken,
                accessToken: accessToken,
                serverAuthCode: serverAuthCode,
                url: formatApiUrl(url.trim()),
                secret: secret.trim(),
                platform: getPlatform(context),
                oneTimePassword: oneTimePassword,
              ));
              completer.future.then((_) => _handleLogin(context: context));
            });
          } catch (error) {
            completer.completeError(error);
            print(error);
          }
        },
        onGoogleSignUpPressed:
            (BuildContext context, Completer<Null> completer) async {
          try {
            googleSignUp((idToken, accessToken, serverAuthCode) {
              store.dispatch(OAuthSignUpRequest(
                completer: completer,
                idToken: idToken,
                accessToken: accessToken,
                serverAuthCode: serverAuthCode,
              ));
              completer.future
                  .then((_) => _handleLogin(context: context, isSignUp: true));
            });
          } catch (error) {
            completer.completeError(error);
            print(error);
          }
        },
        onSignUpPressed: (
          BuildContext context,
          Completer<Null> completer, {
          @required String email,
          @required String password,
        }) async {
          if (store.state.isLoading) {
            return;
          }

          store.dispatch(UserSignUpRequest(
            completer: completer,
            email: email.trim(),
            password: password.trim(),
          ));
          completer.future
              .then((_) => _handleLogin(context: context, isSignUp: true));
        },
        onRecoverPressed: (
          BuildContext context,
          Completer<Null> completer, {
          @required String email,
          @required String url,
          @required String secret,
        }) async {
          if (store.state.isLoading) {
            return;
          }

          if (url.isNotEmpty && !url.startsWith('http')) {
            url = 'https://' + url;
          }

          store.dispatch(RecoverPasswordRequest(
            completer: completer,
            email: email.trim(),
            url: formatApiUrl(url.trim()),
            secret: secret.trim(),
          ));
        },
        onLoginPressed: (
          BuildContext context,
          Completer<Null> completer, {
          @required String email,
          @required String password,
          @required String url,
          @required String secret,
          @required String oneTimePassword,
        }) async {
          if (store.state.isLoading) {
            return;
          }

          if (url.isNotEmpty && !url.startsWith('http')) {
            url = 'https://' + url;
          }

          store.dispatch(UserLoginRequest(
            completer: completer,
            email: email.trim(),
            password: password.trim(),
            url: formatApiUrl(url.trim()),
            secret: secret.trim(),
            platform: getPlatform(context),
            oneTimePassword: oneTimePassword.trim(),
          ));
          completer.future.then((_) => _handleLogin(context: context));
        });
  }
}
