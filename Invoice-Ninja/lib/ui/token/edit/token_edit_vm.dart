import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/settings/settings_actions.dart';
import 'package:invoiceninja_flutter/redux/ui/ui_actions.dart';
import 'package:invoiceninja_flutter/utils/dialogs.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/ui/app/dialogs/error_dialog.dart';
import 'package:invoiceninja_flutter/ui/token/view/token_view_vm.dart';
import 'package:invoiceninja_flutter/redux/token/token_actions.dart';
import 'package:invoiceninja_flutter/data/models/token_model.dart';
import 'package:invoiceninja_flutter/ui/token/edit/token_edit.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class TokenEditScreen extends StatelessWidget {
  const TokenEditScreen({Key key}) : super(key: key);
  static const String route = '/$kSettings/$kSettingsTokenEdit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TokenEditVM>(
      converter: (Store<AppState> store) {
        return TokenEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return TokenEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.token.id),
        );
      },
    );
  }
}

class TokenEditVM {
  TokenEditVM({
    @required this.state,
    @required this.token,
    @required this.company,
    @required this.onChanged,
    @required this.isSaving,
    @required this.origToken,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.isLoading,
  });

  factory TokenEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final token = state.tokenUIState.editing;

    return TokenEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origToken: state.tokenState.map[token.id],
      token: token,
      company: state.company,
      onChanged: (TokenEntity token) {
        store.dispatch(UpdateToken(token));
      },
      onCancelPressed: (BuildContext context) {
        store.dispatch(ViewSettings(
          navigator: Navigator.of(context),
          section: kSettingsTokens,
        ));
      },
      onSavePressed: (BuildContext context) {
        passwordCallback(
            context: context,
            callback: (password, idToken) {
              final localization = AppLocalization.of(context);
              final Completer<TokenEntity> completer =
                  new Completer<TokenEntity>();
              store.dispatch(SaveTokenRequest(
                completer: completer,
                token: token,
                password: password,
                idToken: idToken,
              ));
              return completer.future.then((savedToken) {
                showToast(token.isNew
                    ? localization.createdToken
                    : localization.updatedToken);

                if (isMobile(context)) {
                  store.dispatch(UpdateCurrentRoute(TokenViewScreen.route));
                  if (token.isNew) {
                    Navigator.of(context)
                        .pushReplacementNamed(TokenViewScreen.route);
                  } else {
                    Navigator.of(context).pop(savedToken);
                  }
                } else {
                  viewEntity(context: context, entity: savedToken, force: true);
                }
              }).catchError((Object error) {
                showDialog<ErrorDialog>(
                    context: context,
                    builder: (BuildContext context) {
                      return ErrorDialog(error);
                    });
              });
            });
      },
    );
  }

  final TokenEntity token;
  final CompanyEntity company;
  final Function(TokenEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final TokenEntity origToken;
  final AppState state;
}
