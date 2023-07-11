import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/settings/settings_actions.dart';
import 'package:invoiceninja_flutter/redux/ui/ui_actions.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/ui/app/dialogs/error_dialog.dart';
import 'package:invoiceninja_flutter/ui/webhook/view/webhook_view_vm.dart';
import 'package:invoiceninja_flutter/redux/webhook/webhook_actions.dart';
import 'package:invoiceninja_flutter/data/models/webhook_model.dart';
import 'package:invoiceninja_flutter/ui/webhook/edit/webhook_edit.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class WebhookEditScreen extends StatelessWidget {
  const WebhookEditScreen({Key key}) : super(key: key);

  static const String route = '/$kSettings/$kSettingsWebhookEdit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WebhookEditVM>(
      converter: (Store<AppState> store) {
        return WebhookEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return WebhookEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.webhook.id),
        );
      },
    );
  }
}

class WebhookEditVM {
  WebhookEditVM({
    @required this.state,
    @required this.webhook,
    @required this.company,
    @required this.onChanged,
    @required this.isSaving,
    @required this.origWebhook,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.isLoading,
  });

  factory WebhookEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final webhook = state.webhookUIState.editing;

    return WebhookEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origWebhook: state.webhookState.map[webhook.id],
      webhook: webhook,
      company: state.company,
      onChanged: (WebhookEntity webhook) {
        store.dispatch(UpdateWebhook(webhook));
      },
      onCancelPressed: (BuildContext context) {
        store.dispatch(ViewSettings(
          navigator: Navigator.of(context),
          section: kSettingsWebhooks,
        ));
      },
      onSavePressed: (BuildContext context) {
        final localization = AppLocalization.of(context);
        final Completer<WebhookEntity> completer =
            new Completer<WebhookEntity>();
        store.dispatch(
            SaveWebhookRequest(completer: completer, webhook: webhook));
        return completer.future.then((savedWebhook) {
          showToast(webhook.isNew
              ? localization.createdWebhook
              : localization.updatedWebhook);

          if (isMobile(context)) {
            store.dispatch(UpdateCurrentRoute(WebhookViewScreen.route));
            if (webhook.isNew) {
              Navigator.of(context)
                  .pushReplacementNamed(WebhookViewScreen.route);
            } else {
              Navigator.of(context).pop(savedWebhook);
            }
          } else {
            viewEntity(context: context, entity: savedWebhook, force: true);
          }
        }).catchError((Object error) {
          showDialog<ErrorDialog>(
              context: context,
              builder: (BuildContext context) {
                return ErrorDialog(error);
              });
        });
      },
    );
  }

  final WebhookEntity webhook;
  final CompanyEntity company;
  final Function(WebhookEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final WebhookEntity origWebhook;
  final AppState state;
}
