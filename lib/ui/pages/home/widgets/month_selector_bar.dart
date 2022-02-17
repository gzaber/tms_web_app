//@dart=2.9
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/ui/widgets/custom_icon_button.dart';

class MonthSelectorBar extends StatelessWidget {
  final DateTime date;

  final void Function() leftOnPressed;
  final void Function() rightOnPressed;

  const MonthSelectorBar({
    @required this.date,
    @required this.leftOnPressed,
    @required this.rightOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIHelper.barHeight,
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: UIHelper.themeColor[700],
        borderRadius: UIHelper.customBorderRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomIconButton(
              icon: Icons.arrow_back_ios, iconColor: Colors.white, onPressed: leftOnPressed),
          Text(
            DateFormat('MMMM y').format(DateTime(date.year, date.month)),
            style: Theme.of(context).textTheme.subtitle1.copyWith(
                  color: Colors.white,
                ),
          ),
          CustomIconButton(
              icon: Icons.arrow_forward_ios, iconColor: Colors.white, onPressed: rightOnPressed),
        ],
      ),
    );
  }
}
