//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/task_model.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/ui/pages/home/widgets/task_info_alert_dialog.dart';

class SideTaskList extends StatelessWidget {
  final List<TaskModel> tasks;

  const SideTaskList({
    @required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: List.generate(
          tasks.length,
          (index) {
            return Flexible(
              fit: FlexFit.tight,
              child: InkWell(
                onTap: () {
                  _showTaskInfo(context, tasks[index]);
                },
                child: Container(
                  width: Responsive.getSideTaskListWidth(context),
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 5.0),
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Icon(
                              UIHelper.statusIconList[
                                  UIHelper.taskStatusList.indexOf(tasks[index].status)],
                              size: Responsive.getScheduleFontSize(context) - 2.0,
                              color: UIHelper.computeTextColor(tasks[index].color),
                            ),
                          ),
                        ),
                        TextSpan(
                          text: ' ${tasks[index].name}',
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: UIHelper.computeTextColor(tasks[index].color),
                                fontSize: Responsive.getScheduleFontSize(context),
                              ),
                        ),
                        TextSpan(
                          text: ' - ${tasks[index].description}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                                color: UIHelper.computeTextColor(
                                  tasks[index].color,
                                ),
                                fontSize: Responsive.getScheduleFontSize(context),
                              ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Color(tasks[index].color),
                    borderRadius: UIHelper.customBorderRadius,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _showTaskInfo(BuildContext context, TaskModel task) async {
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
