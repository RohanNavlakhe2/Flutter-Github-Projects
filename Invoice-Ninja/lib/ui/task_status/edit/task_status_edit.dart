import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:invoiceninja_flutter/ui/app/edit_scaffold.dart';
import 'package:invoiceninja_flutter/ui/app/form_card.dart';
import 'package:invoiceninja_flutter/ui/app/forms/color_picker.dart';
import 'package:invoiceninja_flutter/ui/app/forms/decorated_form_field.dart';
import 'package:invoiceninja_flutter/ui/task_status/edit/task_status_edit_vm.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';
import 'package:invoiceninja_flutter/utils/completers.dart';

class TaskStatusEdit extends StatefulWidget {
  const TaskStatusEdit({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final TaskStatusEditVM viewModel;

  @override
  _TaskStatusEditState createState() => _TaskStatusEditState();
}

class _TaskStatusEditState extends State<TaskStatusEdit> {
  static final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_taskStatusEdit');
  final _debouncer = Debouncer();
  bool _autoValidate = false;

  final _nameController = TextEditingController();

  List<TextEditingController> _controllers = [];

  @override
  void didChangeDependencies() {
    _controllers = [
      _nameController,
    ];

    _controllers.forEach((controller) => controller.removeListener(_onChanged));

    final taskStatus = widget.viewModel.taskStatus;
    _nameController.text = taskStatus.name;

    _controllers.forEach((controller) => controller.addListener(_onChanged));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controllers.forEach((controller) {
      controller.removeListener(_onChanged);
      controller.dispose();
    });

    super.dispose();
  }

  void _onChanged() {
    _debouncer.run(() {
      final taskStatus = widget.viewModel.taskStatus
          .rebuild((b) => b..name = _nameController.text.trim());
      if (taskStatus != widget.viewModel.taskStatus) {
        widget.viewModel.onChanged(taskStatus);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final localization = AppLocalization.of(context);
    final taskStatus = viewModel.taskStatus;

    return EditScaffold(
      title: taskStatus.isNew
          ? localization.newTaskStatus
          : localization.editTaskStatus,
      onCancelPressed: (context) => viewModel.onCancelPressed(context),
      onSavePressed: (context) {
        final bool isValid = _formKey.currentState.validate();

        setState(() {
          _autoValidate = !isValid;
        });

        if (!isValid) {
          return;
        }

        viewModel.onSavePressed(context);
      },
      body: Form(
          key: _formKey,
          child: Builder(builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                FormCard(
                  children: <Widget>[
                    DecoratedFormField(
                      controller: _nameController,
                      autocorrect: false,
                      autovalidate: _autoValidate,
                      label: localization.name,
                      validator: (val) => val.isEmpty || val.trim().isEmpty
                          ? localization.pleaseEnterAName
                          : null,
                    ),
                    FormColorPicker(
                      initialValue: taskStatus.color,
                      onSelected: (value) => viewModel.onChanged(
                          taskStatus.rebuild((b) => b..color = value)),
                    ),
                  ],
                ),
              ],
            );
          })),
    );
  }
}
