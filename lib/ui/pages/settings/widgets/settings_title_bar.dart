//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';

class SettingsTitleBar extends StatelessWidget {
  final String title;

  const SettingsTitleBar({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIHelper.barHeight,
      width: double.infinity,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: UIHelper.themeColor[700],
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
