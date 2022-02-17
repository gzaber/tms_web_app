//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/task_model.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_state.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/ui/pages/settings/tasks/widgets/widgets.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

class TaskFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthDataCubit authDataCubit = BlocProvider.of<AuthDataCubit>(context);
    TaskApiCubit taskApiCubit = BlocProvider.of<TaskApiCubit>(context);
    DateRangeCubit dateRangeCubit = BlocProvider.of<DateRangeCubit>(context);
    StatusCubit statusCubit = BlocProvider.of<StatusCubit>(context);
    ColorCubit colorCubit = BlocProvider.of<ColorCubit>(context);
    MembersCubit membersCubit = BlocProvider.of<MembersCubit>(context);

    return BlocBuilder<SettingsCubit, SettingsState>(
      bloc: BlocProvider.of<SettingsCubit>(context),
      builder: (_, state) {
        if (state is SettingsTaskLoadSuccess) {
          dateRangeCubit.update(state.task.dateFrom, state.task.dateTo);
          statusCubit.update(state.task.status);
          colorCubit.update(state.task.color);
          membersCubit.update(state.task.members);

          return _buildDetailsUI(context, authDataCubit, taskApiCubit, state.task.id,
              state.task.name, state.task.description);
        } else {
          return SizedBox();
        }
      },
    );
  }

  Container _buildDetailsUI(BuildContext context, AuthDataCubit authDataCubit,
      TaskApiCubit taskApiCubit, String taskId, String name, String description) {
    return Container(
      child: Column(
        children: [
          Container(
            height: UIHelper.barHeight,
            decoration: BoxDecoration(
              color: UIHelper.themeColor,
              borderRadius: UIHelper.customBorderRadius,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  icon: Icons.clear,
                  iconColor: Colors.white,
                  onPressed: () {
                    BlocProvider.of<SettingsCubit>(context).hideForm();
                  },
                ),
                if (taskId != null)
                  CustomIconButton(
                    icon: Icons.delete,
                    iconColor: Colors.white,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => CustomConfirmDialog(
                          title: 'Delete Task',
                          content: 'Delete this Task?',
                          onOKPressed: () {
                            taskApiCubit.deleteTask(authDataCubit.state.token, taskId);
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                if (taskId != null)
                  CustomIconButton(
                    icon: Icons.save,
                    iconColor: Colors.white,
                    onPressed: () {
                      taskApiCubit.updateTask(
                        authDataCubit.state.token,
                        TaskModel(
                          id: taskId,
                          name: name,
                          description: description,
                          status: BlocProvider.of<StatusCubit>(context).state,
                          dateFrom: BlocProvider.of<DateRangeCubit>(context).state.dateFrom,
                          dateTo: BlocProvider.of<DateRangeCubit>(context).state.dateTo,
                          color: BlocProvider.of<ColorCubit>(context).state,
                          members: BlocProvider.of<MembersCubit>(context).state,
                        ),
                      );
                    },
                  ),
                if (taskId == null)
                  CustomIconButton(
                    icon: Icons.save,
                    iconColor: Colors.white,
                    onPressed: () {
                      taskApiCubit.addTask(
                        authDataCubit.state.token,
                        TaskModel(
                          name: name,
                          description: description,
                          status: BlocProvider.of<StatusCubit>(context).state,
                          dateFrom: BlocProvider.of<DateRangeCubit>(context).state.dateFrom,
                          dateTo: BlocProvider.of<DateRangeCubit>(context).state.dateTo,
                          color: BlocProvider.of<ColorCubit>(context).state,
                          members: BlocProvider.of<MembersCubit>(context).state,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0),
                    CustomTextField(
                      controller: TextEditingController(text: name),
                      hint: 'Task name',
                      obscure: false,
                      onChanged: (val) {
                        name = val;
                      },
                    ),
                    SizedBox(height: 10.0),
                    CustomTextField(
                      controller: TextEditingController(text: description),
                      hint: 'Task description',
                      obscure: false,
                      onChanged: (val) {
                        description = val;
                      },
                    ),
                    SizedBox(height: 10.0),
                    DatePicker(),
                    SizedBox(height: 10.0),
                    StatusRadioGroup(),
                    SizedBox(height: 10.0),
                    ColorPicker(),
                    SizedBox(height: 10.0),
                    MembersList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
