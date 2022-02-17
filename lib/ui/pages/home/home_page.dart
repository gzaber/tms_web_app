//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/task_model.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_state.dart';
import 'package:tms_web_app/ui/pages/home/widgets/widgets.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

import '../../../composition_root.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskApiCubit taskApiCubit;
  AuthDataCubit authDataCubit;
  DateTime schedulerDate = DateTime(DateTime.now().year, DateTime.now().month, 1);

  @override
  void initState() {
    taskApiCubit = BlocProvider.of<TaskApiCubit>(context);
    authDataCubit = BlocProvider.of<AuthDataCubit>(context);
    taskApiCubit.getByDateRange(
      authDataCubit.state.token,
      _getDateFrom(schedulerDate),
      _getDateTo(schedulerDate),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.show(
        context: context,
        title: 'Home',
        username: authDataCubit.state.username,
        icon: Icons.settings,
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompositionRoot.composeSettingsUI(),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MonthSelectorBar(
              date: schedulerDate,
              leftOnPressed: () {
                setState(() {
                  // set actual scheduler date
                  schedulerDate = DateTime(schedulerDate.year, schedulerDate.month - 1, 1);
                  // get actual data
                  taskApiCubit.getByDateRange(
                    authDataCubit.state.token,
                    _getDateFrom(schedulerDate),
                    _getDateTo(schedulerDate),
                  );
                });
              },
              rightOnPressed: () {
                setState(() {
                  // set actual scheduler date
                  schedulerDate = DateTime(schedulerDate.year, schedulerDate.month + 1, 1);
                  // get actual data
                  taskApiCubit.getByDateRange(
                    authDataCubit.state.token,
                    _getDateFrom(schedulerDate),
                    _getDateTo(schedulerDate),
                  );
                });
              },
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DaysOfMonthList(
                    date: schedulerDate,
                  ),
                  Expanded(
                    child: BlocConsumer<TaskApiCubit, TaskApiState>(
                      bloc: taskApiCubit,
                      builder: (_, state) {
                        if (state is TaskApiLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is TaskApiLoadListSuccess) {
                          if (state.tasks.length > 0) {
                            return _buildTaskSchedule(state.tasks, schedulerDate);
                          }
                        }
                        if (state is TaskApiActionSuccess) {
                          taskApiCubit.getByDateRange(
                            authDataCubit.state.token,
                            _getDateFrom(schedulerDate),
                            _getDateTo(schedulerDate),
                          );
                        }
                        if (state is TaskApiActionFailure) {
                          taskApiCubit.getByDateRange(
                            authDataCubit.state.token,
                            _getDateFrom(schedulerDate),
                            _getDateTo(schedulerDate),
                          );
                        }
                        if (state is TaskApiFailure) {
                          return Center(
                            child: Text(
                              state.message,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                      listener: (_, state) {
                        if (state is TaskApiActionSuccess) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              CustomSnackBar.show(state.message, true, context),
                            );
                        }
                        if (state is TaskApiActionFailure) {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              CustomSnackBar.show(state.message, false, context),
                            );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  String _getDateFrom(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(DateTime(date.year, date.month, 1));
  }

  // ===========================================================================
  String _getDateTo(DateTime date) {
    return DateFormat('yyyy-MM-dd')
        .format(DateTime(date.year, date.month, UIHelper.getLastOfMonth(date)));
  }

  // ===========================================================================
  Widget _buildTaskSchedule(List<TaskModel> tasks, DateTime date) => Row(
        children: [
          TaskSchedule(
            nrOfDaysInMonth: UIHelper.getLastOfMonth(date),
            tasks: _getSpecifiedTermTasks(tasks, date),
          ),
          SideTaskList(
            tasks: tasks.where((task) => _isNonSpecifiedTerm(task)).toList(),
          ),
        ],
      );

  // ===========================================================================
  List<TaskModel> _getSpecifiedTermTasks(List<TaskModel> tasks, DateTime date) {
    List<TaskModel> specifiedTermTasks = [];

    tasks.where((task) => !_isNonSpecifiedTerm(task)).toList().forEach((task) {
      // the same day
      if (task.dateFrom == task.dateTo) {
        specifiedTermTasks.add(task);
      } else {
        // the same month
        if (DateTime.parse(task.dateFrom).month == DateTime.parse(task.dateTo).month) {
          for (int i = DateTime.parse(task.dateFrom).day;
              i <= DateTime.parse(task.dateTo).day;
              i++) {
            specifiedTermTasks.add(
              _constructSpecifiedTermTask(i, task),
            );
          }
        }
        // beginning of the month
        if (DateTime.parse(task.dateFrom).month < date.month) {
          for (int i = 1; i <= DateTime.parse(task.dateTo).day; i++) {
            specifiedTermTasks.add(
              _constructSpecifiedTermTask(i, task),
            );
          }
        }
        // end of the month
        if ((DateTime.parse(task.dateTo).month > date.month)) {
          final int lastDayOfMonth = UIHelper.getLastOfMonth(date);
          for (int i = DateTime.parse(task.dateFrom).day; i <= lastDayOfMonth; i++) {
            specifiedTermTasks.add(
              _constructSpecifiedTermTask(i, task),
            );
          }
        }
      }
    });
    return specifiedTermTasks;
  }

  // ===========================================================================
  TaskModel _constructSpecifiedTermTask(int i, TaskModel task) {
    var singleDate = DateFormat('yyyy-MM-dd').format(
      DateTime(DateTime.parse(task.dateFrom).year, DateTime.parse(task.dateFrom).month, i),
    );
    return TaskModel(
      id: task.id,
      name: task.name,
      description: task.description,
      status: task.status,
      dateFrom: singleDate,
      dateTo: singleDate,
      color: task.color,
      members: task.members,
    );
  }

  // ===========================================================================
  bool _isNonSpecifiedTerm(TaskModel task) {
    int lastDayOfMonth = UIHelper.getLastOfMonth(DateTime.parse(task.dateFrom));
    if ((DateTime.parse(task.dateFrom).day == 1) &&
        (DateTime.parse(task.dateTo).day == lastDayOfMonth))
      return true;
    else
      return false;
  }
  // ===========================================================================
}
