import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_design_patterns/widgets/platform_specific/platform_button.dart';

class FilesDialog extends StatelessWidget {
  final String filesText;

  const FilesDialog({
    @required this.filesText,
  }) : assert(filesText != null);

  void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Files'),
      content: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(filesText),
          ),
        ),
      ),
      actions: <Widget>[
        PlatformButton(
          child: Text('Close'),
          materialColor: Colors.black,
          materialTextColor: Colors.white,
          onPressed: () => closeDialog(context),
        ),
      ],
    );
  }
}
