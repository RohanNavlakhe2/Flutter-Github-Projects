import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/data/models/entities.dart';
import 'package:invoiceninja_flutter/redux/payment_term/payment_term_selectors.dart';
import 'package:invoiceninja_flutter/ui/app/entity_dropdown.dart';
import 'package:invoiceninja_flutter/ui/app/forms/app_dropdown_button.dart';
import 'package:invoiceninja_flutter/ui/app/forms/decorated_form_field.dart';
import 'package:invoiceninja_flutter/ui/client/edit/client_edit_vm.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/ui/app/form_card.dart';
import 'package:invoiceninja_flutter/redux/static/static_selectors.dart';

class ClientEditSettings extends StatefulWidget {
  const ClientEditSettings({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final ClientEditVM viewModel;

  @override
  ClientEditSettingsState createState() => new ClientEditSettingsState();
}

class ClientEditSettingsState extends State<ClientEditSettings> {
  final _taskRateController = TextEditingController();
  final _paymentTermsController = TextEditingController();

  List<TextEditingController> _controllers;
  final _debouncer = Debouncer();

  @override
  void didChangeDependencies() {
    _controllers = [
      _taskRateController,
      _paymentTermsController,
    ];

    _controllers
        .forEach((dynamic controller) => controller.removeListener(_onChanged));

    final client = widget.viewModel.client;
    _taskRateController.text = formatNumber(
        client.settings.defaultTaskRate, context,
        formatNumberType: FormatNumberType.inputMoney);
    _paymentTermsController.text = client.settings.defaultPaymentTerms != null
        ? '$client.settings.defaultPaymentTerms'
        : null;

    _controllers
        .forEach((dynamic controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((dynamic controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    _debouncer.run(() {
      final viewModel = widget.viewModel;
      final client = viewModel.client.rebuild((b) => b
        ..settings.defaultTaskRate =
            parseDouble(_taskRateController.text, zeroIsNull: true));
      if (client != viewModel.client) {
        viewModel.onChanged(client);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final client = viewModel.client;

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        FormCard(
          children: <Widget>[
            EntityDropdown(
              entityType: EntityType.currency,
              entityList:
                  memoizedCurrencyList(viewModel.staticState.currencyMap),
              labelText: localization.currency,
              entityId: client.currencyId,
              onSelected: (SelectableEntity currency) => viewModel.onChanged(
                  client.rebuild(
                      (b) => b..settings.currencyId = currency?.id ?? '')),
            ),
            EntityDropdown(
              entityType: EntityType.language,
              entityList:
                  memoizedLanguageList(viewModel.staticState.languageMap),
              labelText: localization.language,
              entityId: client.languageId,
              onSelected: (SelectableEntity language) => viewModel.onChanged(
                  client.rebuild(
                      (b) => b..settings.languageId = language?.id ?? '')),
            ),
            AppDropdownButton<String>(
              showBlank: true,
              labelText: localization.paymentTerm,
              items: memoizedDropdownPaymentTermList(
                      state.paymentTermState.map, state.paymentTermState.list)
                  .map((paymentTermId) {
                final paymentTerm = state.paymentTermState.map[paymentTermId];
                return DropdownMenuItem<String>(
                  child: Text(paymentTerm.name),
                  value: paymentTerm.numDays.toString(),
                );
              }).toList(),
              value: '${client.settings.defaultPaymentTerms}',
              onChanged: (dynamic numDays) {
                viewModel.onChanged(client.rebuild((b) => b
                  ..settings.defaultPaymentTerms =
                      numDays == null ? null : '$numDays'));
              },
            ),
            DecoratedFormField(
              controller: _taskRateController,
              isMoney: true,
              label: localization.taskRate,
              onSavePressed: viewModel.onSavePressed,
            ),
            /*
            BoolDropdownButton(
              label: localization.emailReminders,
              value: client.settings.sendReminders,
              showBlank: true,
              onChanged: (value) => viewModel.onChanged(
                  client.rebuild((b) => b..settings.sendReminders = value)),
            )            
             */
          ],
        ),
        FormCard(children: <Widget>[
          SwitchListTile(
            activeColor: Theme.of(context).accentColor,
            title: Text(localization.emailReminders),
            subtitle: Text(localization.enabled),
            value: client.settings.sendReminders ?? true,
            onChanged: (value) => viewModel.onChanged(client.rebuild((b) =>
                b..settings.sendReminders = value == true ? null : false)),
          ),
        ]),
      ],
    );
  }
}
