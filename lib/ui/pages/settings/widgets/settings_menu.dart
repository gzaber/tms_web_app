//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/helpers/settings_menu_cubit.dart';

class SettingsMenu extends StatefulWidget {
  final bool isAdmin;

  const SettingsMenu({@required this.isAdmin});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  List<bool> isSelected;
  List<String> settingsTitles;
  int settingsIndex;

  @override
  void initState() {
    if (widget.isAdmin) {
      settingsTitles = ['TASKS', 'USERS', 'PROFILE'];
    } else {
      settingsTitles = ['TASKS', 'PROFILE'];
    }
    isSelected = List.generate(
      settingsTitles.length,
      (index) => (BlocProvider.of<SettingsMenuCubit>(context).state == settingsTitles[index])
          ? true
          : false,
    );
    settingsIndex = isSelected.indexOf(true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Responsive.getSettingsMenuWidth(context),
      margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 5.0),
      decoration: BoxDecoration(
        color: UIHelper.themeColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ToggleButtons(
        constraints: BoxConstraints(minHeight: UIHelper.barHeight),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.white,
        selectedColor: UIHelper.themeColor,
        fillColor: Colors.white,
        direction: Responsive.getSettingsMenuDirection(context),
        textStyle: Theme.of(context).textTheme.button,
        children: List.generate(
          settingsTitles.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(settingsTitles[index]),
          ),
        ),
        onPressed: (int index) {
          setState(
            () {
              for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                if (buttonIndex == index) {
                  isSelected[buttonIndex] = true;
                  settingsIndex = buttonIndex;
                  BlocProvider.of<SettingsMenuCubit>(context).update(settingsTitles[settingsIndex]);
                } else {
                  isSelected[buttonIndex] = false;
                }
              }
            },
          );
        },
        isSelected: isSelected,
      ),
    );
  }
}
