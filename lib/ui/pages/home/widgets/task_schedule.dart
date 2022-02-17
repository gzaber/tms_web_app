//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/task_model.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/ui/pages/home/widgets/task_info_alert_dialog.dart';

class TaskSchedule extends StatelessWidget {
  final int nrOfDaysInMonth;
  final List<TaskModel> tasks;

  const TaskSchedule({
    @required this.nrOfDaysInMonth,
    @required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 3.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            nrOfDaysInMonth,
            (index) => Flexible(
              fit: FlexFit.tight,
              child: Row(
                children: List.generate(tasks.length, (idx) {
                  if ((DateTime.parse(tasks[idx].dateFrom).day) == (index + 1)) {
                    return Flexible(
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: () {
                          _showTaskInfo(context, tasks[idx]);
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          margin: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 2.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 2.0),
                                    child: Icon(
                                      UIHelper.statusIconList[
                                          UIHelper.taskStatusList.indexOf(tasks[idx].status)],
                                      size: Responsive.getScheduleFontSize(context) - 2.0,
                                      color: UIHelper.computeTextColor(tasks[idx].color),
                                    ),
                                  ),
                                ),
                                TextSpan(
                                  text: ' ${tasks[idx].name}',
                                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                                      color: UIHelper.computeTextColor(tasks[idx].color),
                                      fontSize: Responsive.getScheduleFontSize(context)),
                                ),
                                TextSpan(
                                  text: ' - ${tasks[idx].description}',
                                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        color: UIHelper.computeTextColor(tasks[idx].color),
                                        fontSize: Responsive.getScheduleFontSize(context),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(tasks[idx].color) == null
                                ? UIHelper.themeColor[400]
                                : Color(tasks[idx].color),
                            borderRadius: UIHelper.customBorderRadius,
                          ),
                        ),
                      ),
                    );
                  } else
                    return Container();
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskInfo(BuildContext context, TaskModel task) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return TaskInfoAlertDialog(
          task: task,
          taskApiCubit: BlocProvider.of<TaskApiCubit>(context),
          authDataCubit: BlocProvider.of<AuthDataCubit>(context),
        );
      },
    );
  }
}
