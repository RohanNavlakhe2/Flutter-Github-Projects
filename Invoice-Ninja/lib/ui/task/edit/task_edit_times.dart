import 'package:invoiceninja_flutter/data/models/task_model.dart';
import 'package:invoiceninja_flutter/ui/app/forms/date_picker.dart';
import 'package:invoiceninja_flutter/ui/app/forms/duration_picker.dart';
import 'package:invoiceninja_flutter/ui/app/forms/time_picker.dart';
import 'package:invoiceninja_flutter/ui/app/help_text.dart';
import 'package:invoiceninja_flutter/ui/app/responsive_padding.dart';
import 'package:invoiceninja_flutter/ui/task/edit/task_edit_times_vm.dart';
import 'package:invoiceninja_flutter/ui/task/task_time_view.dart';
import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class TaskEditTimes extends StatefulWidget {
  const TaskEditTimes({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final TaskEditTimesVM viewModel;

  @override
  _TaskEditTimesState createState() => _TaskEditTimesState();
}

class _TaskEditTimesState extends State<TaskEditTimes> {
  TaskTime selectedTaskTime;

  void _showTaskTimeEditor(TaskTime taskTime, BuildContext context) {
    showDialog<ResponsivePadding>(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          final viewModel = widget.viewModel;
          final task = viewModel.task;
          final taskTimes = task.getTaskTimes();
          return TimeEditDetails(
            viewModel: viewModel,
            taskTime: taskTime,
            index: taskTimes.indexOf(
                taskTimes.firstWhere((time) => time.equalTo(taskTime))),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final task = viewModel.task;
    final taskTimes = task.getTaskTimes();
    final taskTime = viewModel.taskTimeIndex != null &&
            taskTimes.length > viewModel.taskTimeIndex
        ? taskTimes[viewModel.taskTimeIndex]
        : null;

    if (taskTime != null && taskTime != selectedTaskTime) {
      viewModel.clearSelectedTaskTime();
      WidgetsBinding.instance.addPostFrameCallback((duration) {
        _showTaskTimeEditor(taskTime, context);
      });
    }

    if (task.getTaskTimes().isEmpty) {
      return HelpText(localization.clickPlusToAddTime);
    }

    final taskTimeWidgets = task
        .getTaskTimes()
        .toList()
        .reversed
        .map<Widget>((taskTime) => TaskTimeListTile(
              task: task,
              taskTime: taskTime,
              onTap: (context) => _showTaskTimeEditor(taskTime, context),
            ));

    return ListView(
      children: taskTimeWidgets.toList(),
    );
  }
}

class TimeEditDetails extends StatefulWidget {
  const TimeEditDetails({
    Key key,
    @required this.index,
    @required this.taskTime,
    @required this.viewModel,
  }) : super(key: key);

  final int index;
  final TaskTime taskTime;
  final TaskEditTimesVM viewModel;

  @override
  TimeEditDetailsState createState() => TimeEditDetailsState();
}

class TimeEditDetailsState extends State<TimeEditDetails> {
  TaskTime _taskTime = TaskTime();
  int _dateUpdatedAt = 0;
  int _startUpdatedAt = 0;
  int _endUpdatedAt = 0;
  int _durationUpdateAt = 0;

  @override
  void didChangeDependencies() {
    _taskTime = widget.taskTime;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DatePicker(
              key: ValueKey('__date_${_startUpdatedAt}__'),
              labelText: localization.date,
              selectedDate: _taskTime.startDate == null
                  ? null
                  : convertDateTimeToSqlDate(_taskTime.startDate.toLocal()),
              onSelected: (date) {
                setState(() {
                  _taskTime = _taskTime.copyWithDate(date);
                  viewModel.onUpdatedTaskTime(_taskTime, widget.index);
                  _dateUpdatedAt = DateTime.now().millisecondsSinceEpoch;
                });
              },
            ),
            TimePicker(
              key: ValueKey('__start_time_${_durationUpdateAt}__'),
              labelText: localization.startTime,
              selectedDate: _taskTime.startDate,
              selectedDateTime: _taskTime.startDate,
              onSelected: (timeOfDay) {
                setState(() {
                  _taskTime = _taskTime.copyWithStartDateTime(timeOfDay);
                  viewModel.onUpdatedTaskTime(_taskTime, widget.index);
                  _startUpdatedAt = DateTime.now().millisecondsSinceEpoch;
                });
              },
            ),
            TimePicker(
              key: ValueKey('__end_time_${_durationUpdateAt}__'),
              labelText: localization.endTime,
              selectedDate: _taskTime.startDate,
              selectedDateTime: _taskTime.endDate,
              isEndTime: true,
              onSelected: (timeOfDay) {
                setState(() {
                  _taskTime = _taskTime.copyWithEndDateTime(timeOfDay);
                  viewModel.onUpdatedTaskTime(_taskTime, widget.index);
                  _endUpdatedAt = DateTime.now().millisecondsSinceEpoch;
                });
              },
            ),
            DurationPicker(
              key: ValueKey(
                  '__duration_${_startUpdatedAt}_${_endUpdatedAt}_${_dateUpdatedAt}__'),
              labelText: localization.duration,
              onSelected: (Duration duration) {
                setState(() {
                  _taskTime = _taskTime.copyWithDuration(duration);
                  viewModel.onUpdatedTaskTime(_taskTime, widget.index);
                  _durationUpdateAt = DateTime.now().millisecondsSinceEpoch;
                });
              },
              selectedDuration:
                  (_taskTime.startDate == null || _taskTime.endDate == null)
                      ? null
                      : _taskTime.duration,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(localization.remove.toUpperCase()),
          onPressed: () {
            widget.viewModel.onRemoveTaskTimePressed(widget.index);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(localization.done.toUpperCase()),
          onPressed: () {
            widget.viewModel.onDoneTaskTimePressed();
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}