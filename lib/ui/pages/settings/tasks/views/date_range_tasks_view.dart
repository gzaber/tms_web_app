//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_state.dart';
import 'package:tms_web_app/ui/pages/settings/tasks/widgets/widgets.dart';

class DateRangeTasksView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();
    AuthDataCubit authDataCubit = BlocProvider.of<AuthDataCubit>(context);
    TaskApiCubit taskApiCubit = BlocProvider.of<TaskApiCubit>(context);
    SettingsCubit settingsCubit = BlocProvider.of<SettingsCubit>(context);
    DateRangeCubit dateRangeCubit = BlocProvider.of<DateRangeCubit>(context);
    StatusCubit statusCubit = BlocProvider.of<StatusCubit>(context);
    ColorCubit colorCubit = BlocProvider.of<ColorCubit>(context);
    MembersCubit membersCubit = BlocProvider.of<MembersCubit>(context);

    dateRangeCubit.reset();
    statusCubit.reset();
    colorCubit.reset();
    membersCubit.reset();

    settingsCubit.hideForm();
    taskApiCubit.getByDateRange(
      authDataCubit.state.token,
      dateRangeCubit.state.dateFrom,
      dateRangeCubit.state.dateTo,
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: DatePicker(
            onSetDate: () {
              settingsCubit.hideForm();
              taskApiCubit.getByDateRange(
                authDataCubit.state.token,
                dateRangeCubit.state.dateFrom,
                dateRangeCubit.state.dateTo,
              );
            },
          ),
        ),
        SizedBox(height: 5.0),
        Expanded(
          child: BlocBuilder<TaskApiCubit, TaskApiState>(
            builder: (_, state) {
              if (state is TaskApiLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is TaskApiLoadListSuccess) {
                return TaskListView(
                  tasks: state.tasks,
                  scrollController: _scrollController,
                );
              }
              if (state is TaskApiActionSuccess) {
                settingsCubit.hideForm();
                taskApiCubit.getByDateRange(
                  authDataCubit.state.token,
                  dateRangeCubit.state.dateFrom,
                  dateRangeCubit.state.dateTo,
                );
              }
              if (state is TaskApiActionFailure) {
                taskApiCubit.getByDateRange(
                  authDataCubit.state.token,
                  dateRangeCubit.state.dateFrom,
                  dateRangeCubit.state.dateTo,
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
              return SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
