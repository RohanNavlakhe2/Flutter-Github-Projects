import 'package:flutter/material.dart';

import 'package:flutter_design_patterns/constants.dart';
import 'package:flutter_design_patterns/design_patterns/factory_method/alert_dialogs/android_alert_dialog.dart';
import 'package:flutter_design_patterns/design_patterns/factory_method/alert_dialogs/ios_alert_dialog.dart';
import 'package:flutter_design_patterns/design_patterns/factory_method/custom_dialog.dart';
import 'package:flutter_design_patterns/widgets/design_patterns/factory_method/dialog_selection.dart';
import 'package:flutter_design_patterns/widgets/platform_specific/platform_button.dart';

class FactoryMethodExample extends StatefulWidget {
  @override
  _FactoryMethodExampleState createState() => _FactoryMethodExampleState();
}

class _FactoryMethodExampleState extends State<FactoryMethodExample> {
  final List<CustomDialog> customDialogList = [
    AndroidAlertDialog(),
    IosAlertDialog(),
  ];

  int _selectedDialogIndex = 0;

  Future _showCustomDialog(BuildContext context) async {
    var selectedDialog = customDialogList[_selectedDialogIndex];

    await selectedDialog.show(context);
  }

  void _setSelectedDialogIndex(int index) {
    setState(() {
      _selectedDialogIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: paddingL),
        child: Column(
          children: <Widget>[
            DialogSelection(
              customDialogList: customDialogList,
              selectedIndex: _selectedDialogIndex,
              onChanged: _setSelectedDialogIndex,
            ),
            const SizedBox(height: spaceL),
            PlatformButton(
              child: Text('Show Dialog'),
              materialColor: Colors.black,
              materialTextColor: Colors.white,
              onPressed: () => _showCustomDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
