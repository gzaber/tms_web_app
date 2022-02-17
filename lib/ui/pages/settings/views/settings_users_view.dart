//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_state.dart';
import 'package:tms_web_app/ui/pages/settings/users/views/views.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

class SettingsUsersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: Responsive.getSettingsPadding(context)),
            child: Responsive.isLargeScreen(context)
                ? CustomTabView(
                    titles: ['USERS', 'EMAILS'],
                    tabViews: [
                      UsersView(),
                      EmailsView(),
                    ],
                  )
                : BlocBuilder<SettingsCubit, SettingsState>(
                    bloc: BlocProvider.of<SettingsCubit>(context),
                    builder: (_, state) {
                      if (state is SettingsUserLoadSuccess) {
                        return EmailUserFormView();
                      }
                      if (state is SettingsEmailLoadSuccess) {
                        return EmailUserFormView();
                      }
                      return CustomTabView(
                        titles: ['USERS', 'EMAILS'],
                        tabViews: [
                          UsersView(),
                          EmailsView(),
                        ],
                      );
                    },
                  ),
          ),
        ),
        SizedBox(width: Responsive.getSettingsSizedBoxWidth(context)),
        Responsive.isLargeScreen(context)
            ? Flexible(
                child: EmailUserFormView(),
              )
            : SizedBox(),
      ],
    );
  }
}
