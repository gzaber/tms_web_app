//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_state.dart';
import 'package:tms_web_app/ui/pages/settings/tasks/views/views.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

class SettingsTasksView extends StatelessWidget {
  final bool isAdmin;

  const SettingsTasksView({@required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isAdmin
            ? Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: Responsive.getSettingsPadding(context)),
                    child: CustomElevatedButton(
                      text: 'NEW',
                      onPressed: () {
                        BlocProvider.of<StatusCubit>(context).reset();
                        BlocProvider.of<ColorCubit>(context).reset();
                        BlocProvider.of<MembersCubit>(context).reset();

                        BlocProvider.of<SettingsCubit>(context).showAddTaskForm();
                      },
                    ),
                  ),
                  SizedBox(height: 5.0),
                ],
              )
            : SizedBox(),
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: Responsive.getSettingsPadding(context)),
                  child: Responsive.isLargeScreen(context)
                      ? BlocProvider(
                          create: (context) => DateRangeCubit(),
                          child: CustomTabView(
                            titles: ['ALL', 'BY DATE RANGE'],
                            tabViews: [
                              AllTasksView(),
                              DateRangeTasksView(),
                            ],
                          ),
                        )
                      : BlocBuilder<SettingsCubit, SettingsState>(
                          bloc: BlocProvider.of<SettingsCubit>(context),
                          builder: (_, state) {
                            if (state is SettingsTaskLoadSuccess) {
                              return BlocProvider(
                                create: (context) => DateRangeCubit(),
                                child: TaskFormView(),
                              );
                            } else {
                              return BlocProvider(
                                create: (context) => DateRangeCubit(),
                                child: CustomTabView(
                                  titles: ['ALL', 'BY DATE RANGE'],
                                  tabViews: [
                                    AllTasksView(),
                                    DateRangeTasksView(),
                                  ],
                                ),
                              );
                            }
                          },
                        ),

                  //
                ),
              ),
              SizedBox(width: Responsive.getSettingsSizedBoxWidth(context)),
              Responsive.isLargeScreen(context)
                  ? Flexible(
                      child: BlocProvider(
                        create: (context) => DateRangeCubit(),
                        child: TaskFormView(),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
