//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/task_model.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';

class TaskListView extends StatelessWidget {
  final List<TaskModel> tasks;
  final ScrollController scrollController;

  const TaskListView({
    @required this.tasks,
    @required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    bool isAdmin = BlocProvider.of<AuthDataCubit>(context).state.role == "admin" ? true : false;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        child: ListView.builder(
          itemCount: tasks.length,
          controller: scrollController,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (isAdmin) {
                  BlocProvider.of<SettingsCubit>(context).showTaskForm(tasks[index]);
                }
              },
              child: Card(
                color: Color(tasks[index].color),
                elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${tasks[index].name}',
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                    color: UIHelper.computeTextColor(tasks[index].color),
                                  ),
                            ),
                            TextSpan(
                              text: ' - ${tasks[index].description}\n',
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    color: UIHelper.computeTextColor(tasks[index].color),
                                  ),
                            ),
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2.0),
                                child: Icon(
                                  UIHelper.statusIconList[
                                      UIHelper.taskStatusList.indexOf(tasks[index].status)],
                                  size: 12.0,
                                  color: UIHelper.computeTextColor(tasks[index].color),
                                ),
                              ),
                            ),
                            TextSpan(
                              text:
                                  '  ${UIHelper.formatTaskTerm(tasks[index].dateFrom, tasks[index].dateTo)}',
                              style: Theme.of(context).textTheme.bodyText2.copyWith(
                                    color: UIHelper.computeTextColor(tasks[index].color),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Column(
                          children: List.generate(
                            tasks[index].members.length,
                            (idx) => Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 15.0,
                                  color: UIHelper.computeTextColor(tasks[index].color),
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  tasks[index].members[idx],
                                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                                        color: UIHelper.computeTextColor(tasks[index].color),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
