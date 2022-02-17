//@dart=2.9

import 'package:flutter/material.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/ui/pages/settings/profile/views/views.dart';
import 'package:tms_web_app/ui/widgets/widgets.dart';

class SettingsProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(left: Responsive.getSettingsPadding(context)),
            child: CustomTabView(
              titles: ['USERNAME', 'PASSWORD'],
              tabViews: [
                UsernameFormView(),
                PasswordFormView(),
              ],
            ),
          ),
        ),
        SizedBox(width: Responsive.getSettingsSizedBoxWidth(context)),
        Responsive.isLargeScreen(context)
            ? Flexible(
                child: SizedBox(),
              )
            : SizedBox(),
      ],
    );
  }
}
