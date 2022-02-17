//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_state.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';
import 'package:tms_web_app/state_management/helpers/settings_menu_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_state.dart';
import 'package:tms_web_app/ui/pages/settings/views/views.dart';
import 'package:tms_web_app/ui/pages/settings/widgets/widgets.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

import '../../../composition_root.dart';

const TASKS = 'TASKS';
const USERS = 'USERS';
const PROFILE = 'PROFILE';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isAdmin = BlocProvider.of<AuthDataCubit>(context).state.role == "admin" ? true : false;
    return Scaffold(
      appBar: CustomAppBar.show(
        context: context,
        title: 'Settings',
        username: BlocProvider.of<AuthDataCubit>(context).state.username,
        icon: Icons.preview,
        onPressed: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CompositionRoot.composeHomeUI(),
            ),
          );
        },
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsMenuCubit, String>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SettingsTitleBar(title: state),
                Expanded(
                  child: Responsive.getSettingsLayout(
                    context,
                    SettingsMenu(isAdmin: isAdmin),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 5.0, 5.0),
                        child: _buildContent(context, isAdmin, state),
                      ),
                    ),
                  ),
                ),
                BlocListener<AuthApiCubit, AuthApiState>(
                  child: SizedBox(),
                  listener: (_, state) {
                    if (state is AuthApiActionSuccess) {
                      BlocProvider.of<SettingsCubit>(context).hideForm();
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          CustomSnackBar.show(state.message, true, context),
                        );
                    }
                    if (state is AuthApiActionFailure) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          CustomSnackBar.show(state.message, false, context),
                        );
                    }
                  },
                ),
                BlocListener<TaskApiCubit, TaskApiState>(
                  child: SizedBox(),
                  listener: (_, state) {
                    if (state is TaskApiActionSuccess) {
                      BlocProvider.of<SettingsCubit>(context).hideForm();
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
              ],
            );
          },
        ),
      ),
    );
  }

  _buildContent(BuildContext context, bool isAdmin, String view) {
    BlocProvider.of<SettingsCubit>(context).hideForm();
    switch (view) {
      case TASKS:
        return SettingsTasksView(isAdmin: isAdmin);
      case USERS:
        return SettingsUsersView();
      case PROFILE:
        return SettingsProfileView();
    }
  }
}
