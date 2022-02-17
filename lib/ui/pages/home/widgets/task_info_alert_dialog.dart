//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/task_model.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/ui/widgets/custom_radio_row.dart';

class TaskInfoAlertDialog extends StatefulWidget {
  final TaskModel task;
  final TaskApiCubit taskApiCubit;
  final AuthDataCubit authDataCubit;

  const TaskInfoAlertDialog({
    @required this.task,
    @required this.taskApiCubit,
    @required this.authDataCubit,
  });

  @override
  State<TaskInfoAlertDialog> createState() => _TaskInfoAlertDialogState();
}

class _TaskInfoAlertDialogState extends State<TaskInfoAlertDialog> {
  String _status;

  @override
  void initState() {
    _status = widget.task.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        decoration: BoxDecoration(
          color: Color(widget.task.color),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(3.0),
            topRight: Radius.circular(3.0),
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: Text(
          'Task info',
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(color: UIHelper.computeTextColor(widget.task.color)),
        ),
      ),
      titlePadding: const EdgeInsets.all(0.0),
      backgroundColor: Colors.white,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.task.name,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: 5.0),
            Text(
              widget.task.description,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 5.0),
            const Divider(),
            Column(
              children: List.generate(
                UIHelper.taskStatusList.length,
                (index) => CustomRadioRow(
                  title: UIHelper.taskStatusList[index],
                  value: UIHelper.taskStatusList[index],
                  groupValue: _status,
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                ),
              ),
            ),
            if (widget.task.members.isNotEmpty) const Divider(),
            Column(
              children: List.generate(
                widget.task.members.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: UIHelper.disabledColor,
                        size: 15.0,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        widget.task.members[index],
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          child: Text(
            'Cancel',
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Theme.of(context).primaryColorDark),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Theme.of(context).primaryColorDark),
          ),
          onPressed: () {
            widget.taskApiCubit.updateTaskStatus(
              widget.authDataCubit.state.token,
              widget.task.id,
              _status,
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
