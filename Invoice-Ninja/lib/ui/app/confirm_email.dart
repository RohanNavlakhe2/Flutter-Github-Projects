import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/ui/app/confirm_email_vm.dart';
import 'package:invoiceninja_flutter/ui/app/loading_indicator.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class ConfirmEmail extends StatelessWidget {
  const ConfirmEmail({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final ConfirmEmailVM viewModel;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final state = viewModel.state;

    return Material(
      color: Theme.of(context).cardColor,
      child: state.isLoading
          ? LoadingIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localization.confirmYourEmailAddress,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: viewModel.onResendPressed,
                      child: Text(localization.resendEmail),
                    ),
                    SizedBox(
                      width: kTableColumnGap,
                    ),
                    ElevatedButton(
                      onPressed: viewModel.onRefreshPressed,
                      child: Text(localization.refreshData),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
