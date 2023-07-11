import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/ui/ui_actions.dart';
import 'package:invoiceninja_flutter/ui/payment_term/payment_term_screen.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/ui/app/dialogs/error_dialog.dart';
import 'package:invoiceninja_flutter/redux/payment_term/payment_term_actions.dart';
import 'package:invoiceninja_flutter/data/models/payment_term_model.dart';
import 'package:invoiceninja_flutter/ui/payment_term/edit/payment_term_edit.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class PaymentTermEditScreen extends StatelessWidget {
  const PaymentTermEditScreen({Key key}) : super(key: key);
  static const String route = '/$kSettings/$kSettingsPaymentTermEdit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PaymentTermEditVM>(
      converter: (Store<AppState> store) {
        return PaymentTermEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return PaymentTermEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.paymentTerm.id),
        );
      },
    );
  }
}

class PaymentTermEditVM {
  PaymentTermEditVM({
    @required this.state,
    @required this.paymentTerm,
    @required this.company,
    @required this.onChanged,
    @required this.isSaving,
    @required this.origPaymentTerm,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.isLoading,
  });

  factory PaymentTermEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final paymentTerm = state.paymentTermUIState.editing;

    return PaymentTermEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origPaymentTerm: state.paymentTermState.map[paymentTerm.id],
      paymentTerm: paymentTerm,
      company: state.company,
      onChanged: (PaymentTermEntity paymentTerm) {
        store.dispatch(UpdatePaymentTerm(paymentTerm));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(
            context: context, entity: PaymentTermEntity(), force: true);
        store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
      },
      onSavePressed: (BuildContext context) {
        final localization = AppLocalization.of(context);
        final Completer<PaymentTermEntity> completer =
            new Completer<PaymentTermEntity>();
        store.dispatch(SavePaymentTermRequest(
            completer: completer, paymentTerm: paymentTerm));
        return completer.future.then((savedPaymentTerm) {
          showToast(paymentTerm.isNew
              ? localization.createdPaymentTerm
              : localization.updatedPaymentTerm);

          if (isMobile(context)) {
            store.dispatch(UpdateCurrentRoute(PaymentTermScreen.route));
            if (paymentTerm.isNew) {
              Navigator.of(context)
                  .pushReplacementNamed(PaymentTermScreen.route);
            } else {
              Navigator.of(context).pop(savedPaymentTerm);
            }
          } else {
            viewEntitiesByType(
                context: context, entityType: EntityType.paymentTerm);
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

  final PaymentTermEntity paymentTerm;
  final CompanyEntity company;
  final Function(PaymentTermEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final PaymentTermEntity origPaymentTerm;
  final AppState state;
}
