import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_design_patterns/design_patterns/chain_of_responsibility/log_message.dart';

class LogMessagesColumn extends StatelessWidget {
  final List<LogMessage> logMessages;

  const LogMessagesColumn({
    @required this.logMessages,
  }) : assert(logMessages != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var logMessage in logMessages)
          Row(
            children: <Widget>[
              Expanded(
                child: logMessage.getFormattedMessage(),
              ),
            ],
          )
      ],
    );
  }
}
