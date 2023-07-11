import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/ui/app/lists/activity_list_tile.dart';
import 'package:invoiceninja_flutter/ui/app/lists/list_divider.dart';
import 'package:invoiceninja_flutter/ui/app/loading_indicator.dart';
import 'package:invoiceninja_flutter/ui/client/view/client_view_vm.dart';

class ClientViewActivity extends StatefulWidget {
  const ClientViewActivity({Key key, this.viewModel}) : super(key: key);

  final ClientViewVM viewModel;

  @override
  _ClientViewActivityState createState() => _ClientViewActivityState();
}

class _ClientViewActivityState extends State<ClientViewActivity> {
  @override
  void didChangeDependencies() {
    if (widget.viewModel.client.isStale) {
      widget.viewModel.onRefreshed(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final client = widget.viewModel.client;
    final activities = client.activities;

    if (!client.isLoaded) {
      return LoadingIndicator();
    }

    return ListView.separated(
      itemCount: activities.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      separatorBuilder: (context, index) => ListDivider(),
      itemBuilder: (BuildContext context, index) {
        final activity = activities[index];
        return ActivityListTile(activity: activity);
      },
    );
  }
}
