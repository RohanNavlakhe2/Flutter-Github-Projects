import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/redux/app/app_actions.dart';
import 'package:invoiceninja_flutter/redux/ui/ui_actions.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/ui/app/dialogs/error_dialog.dart';
import 'package:invoiceninja_flutter/ui/task_status/view/task_status_view_vm.dart';
import 'package:invoiceninja_flutter/redux/task_status/task_status_actions.dart';
import 'package:invoiceninja_flutter/data/models/task_status_model.dart';
import 'package:invoiceninja_flutter/ui/task_status/edit/task_status_edit.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';

class TaskStatusEditScreen extends StatelessWidget {
  const TaskStatusEditScreen({Key key}) : super(key: key);
  static const String route = '/$kSettings/$kSettingsTaskStatusEdit';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TaskStatusEditVM>(
      converter: (Store<AppState> store) {
        return TaskStatusEditVM.fromStore(store);
      },
      builder: (context, viewModel) {
        return TaskStatusEdit(
          viewModel: viewModel,
          key: ValueKey(viewModel.taskStatus.id),
        );
      },
    );
  }
}

class TaskStatusEditVM {
  TaskStatusEditVM({
    @required this.state,
    @required this.taskStatus,
    @required this.company,
    @required this.onChanged,
    @required this.isSaving,
    @required this.origTaskStatus,
    @required this.onSavePressed,
    @required this.onCancelPressed,
    @required this.isLoading,
  });

  factory TaskStatusEditVM.fromStore(Store<AppState> store) {
    final state = store.state;
    final taskStatus = state.taskStatusUIState.editing;

    return TaskStatusEditVM(
      state: state,
      isLoading: state.isLoading,
      isSaving: state.isSaving,
      origTaskStatus: state.taskStatusState.map[taskStatus.id],
      taskStatus: taskStatus,
      company: state.company,
      onChanged: (TaskStatusEntity taskStatus) {
        store.dispatch(UpdateTaskStatus(taskStatus));
      },
      onCancelPressed: (BuildContext context) {
        createEntity(context: context, entity: TaskStatusEntity(), force: true);
        store.dispatch(UpdateCurrentRoute(state.uiState.previousRoute));
      },
      onSavePressed: (BuildContext context) {
        final localization = AppLocalization.of(context);
        final Completer<TaskStatusEntity> completer =
            new Completer<TaskStatusEntity>();
        store.dispatch(SaveTaskStatusRequest(
            completer: completer, taskStatus: taskStatus));
        return completer.future.then((savedTaskStatus) {
          showToast(taskStatus.isNew
              ? localization.createdTaskStatus
              : localization.updatedTaskStatus);

          if (isMobile(context)) {
            store.dispatch(UpdateCurrentRoute(TaskStatusViewScreen.route));
            if (taskStatus.isNew) {
              Navigator.of(context)
                  .pushReplacementNamed(TaskStatusViewScreen.route);
            } else {
              Navigator.of(context).pop(savedTaskStatus);
            }
          } else {
            viewEntity(context: context, entity: savedTaskStatus, force: true);
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

  final TaskStatusEntity taskStatus;
  final CompanyEntity company;
  final Function(TaskStatusEntity) onChanged;
  final Function(BuildContext) onSavePressed;
  final Function(BuildContext) onCancelPressed;
  final bool isLoading;
  final bool isSaving;
  final TaskStatusEntity origTaskStatus;
  final AppState state;
}
