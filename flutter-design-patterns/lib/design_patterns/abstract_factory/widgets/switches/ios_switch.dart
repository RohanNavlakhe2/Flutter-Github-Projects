import 'package:flutter/cupertino.dart';

import 'package:flutter_design_patterns/design_patterns/abstract_factory/widgets/iswitch.dart';

class IosSwitch implements ISwitch {
  @override
  Widget render(bool value, ValueSetter<bool> onChanged) {
    return CupertinoSwitch(
      value: value,
      onChanged: onChanged,
    );
  }
}
