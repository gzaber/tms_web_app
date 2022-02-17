//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_state.dart';
import 'package:tms_web_app/ui/pages/settings/tasks/widgets/task_list_view.dart';

class AllTasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    SettingsCubit settingsCubit = BlocProvider.of<SettingsCubit>(context);
    TaskApiCubit taskApiCubit = BlocProvider.of<TaskApiCubit>(context);
    AuthDataCubit authDataCubit = BlocProvider.of<AuthDataCubit>(context);
    DateRangeCubit dateRangeCubit = BlocProvider.of<DateRangeCubit>(context);
    StatusCubit statusCubit = BlocProvider.of<StatusCubit>(context);
    ColorCubit colorCubit = BlocProvider.of<ColorCubit>(context);
    MembersCubit membersCubit = BlocProvider.of<MembersCubit>(context);

    settingsCubit.hideForm();
    dateRangeCubit.reset();
    statusCubit.reset();
    colorCubit.reset();
    membersCubit.reset();

    taskApiCubit.getAll(authDataCubit.state.token);

    return BlocBuilder<TaskApiCubit, TaskApiState>(
      builder: (_, state) {
        if (state is TaskApiLoading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is TaskApiLoadListSuccess) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TaskListView(
              tasks: state.tasks,
              scrollController: _scrollController,
            ),
          );
        }
        if (state is TaskApiActionSuccess) {
          settingsCubit.hideForm();
          taskApiCubit.getAll(authDataCubit.state.token);
        }
        if (state is TaskApiActionFailure) {
          taskApiCubit.getAll(authDataCubit.state.token);
        }
        if (state is TaskApiFailure) {
          return Center(
            child: Text(
              state.message,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
