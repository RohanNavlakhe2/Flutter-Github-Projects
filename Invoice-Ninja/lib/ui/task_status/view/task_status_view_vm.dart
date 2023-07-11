import 'dart:async';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/redux/ui/ui_actions.dart';
import 'package:invoiceninja_flutter/ui/task_status/task_status_screen.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/redux/task_status/task_status_actions.dart';
import 'package:invoiceninja_flutter/data/models/task_status_model.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/ui/task_status/view/task_status_view.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class TaskStatusViewScreen extends StatelessWidget {
  const TaskStatusViewScreen({
    Key key,
    this.isFilter = false,
  }) : super(key: key);
  static const String route = '/$kSettings/$kSettingsTaskStatusView';
  final bool isFilter;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TaskStatusViewVM>(
      converter: (Store<AppState> store) {
        return TaskStatusViewVM.fromStore(store);
      },
      builder: (context, vm) {
        return TaskStatusView(
          viewModel: vm,
          isFilter: isFilter,
        );
      },
    );
  }
}

class TaskStatusViewVM {
  TaskStatusViewVM({
    @required this.state,
    @required this.taskStatus,
    @required this.company,
    @required this.onEntityAction,
    @required this.onRefreshed,
    @required this.isSaving,
    @required this.isLoading,
    @required this.isDirty,
    @required this.onBackPressed,
  });

  factory TaskStatusViewVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final taskStatus =
        state.taskStatusState.map[state.taskStatusUIState.selectedId] ??
            TaskStatusEntity(id: state.taskStatusUIState.selectedId);

    Future<Null> _handleRefresh(BuildContext context) {
      final completer = snackBarCompleter<Null>(
          context, AppLocalization.of(context).refreshComplete);
      store.dispatch(
          LoadTaskStatus(completer: completer, taskStatusId: taskStatus.id));
      return completer.future;
    }

    return TaskStatusViewVM(
      state: state,
      company: state.company,
      isSaving: state.isSaving,
      isLoading: state.isLoading,
      isDirty: taskStatus.isNew,
      taskStatus: taskStatus,
      onRefreshed: (context) => _handleRefresh(context),
      onEntityAction: (BuildContext context, EntityAction action) =>
          handleEntitiesActions(context, [taskStatus], action, autoPop: true),
      onBackPressed: () =>
          store.dispatch(UpdateCurrentRoute(TaskStatusScreen.route)),
    );
  }

  final AppState state;
  final TaskStatusEntity taskStatus;
  final CompanyEntity company;
  final Function(BuildContext, EntityAction) onEntityAction;
  final Function(BuildContext) onRefreshed;
  final Function onBackPressed;
  final bool isSaving;
  final bool isLoading;
  final bool isDirty;
}
