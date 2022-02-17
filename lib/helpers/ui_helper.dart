//@dart=2.9
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UIHelper {
  static const themeColor = Colors.indigo;
  static const disabledColor = Colors.grey;
  static double barHeight = 40.0;
  static final customBorderRadius = BorderRadius.circular(5.0);

  static List<String> taskStatusList = ['todo', 'during', 'done'];
  static List<String> userRoleList = ['admin', 'user'];
  static List<IconData> statusIconList = [
    Icons.hourglass_empty,
    Icons.hourglass_top,
    Icons.hourglass_full,
  ];

  static final materialColors = [
    4293467747,
    4294198070,
    4294924066,
    4294940672,
    4294951175,
    4294961979,
    4291681337,
    4287349578,
    4283215696,
    4278228616,
    4278238420,
    4278430196,
    4280391411,
    4282339765,
    4288423856,
    4284955319,
    4284513675,
    4286141768,
    4288585374,
  ];

  static Color computeTextColor(int backgroundColor) {
    if (Color(backgroundColor).computeLuminance() > 0.34)
      return Colors.black;
    else
      return Colors.white;
  }

  static String formatTaskTerm(String dateFrom, String dateTo) {
    int lastDayOfMonth = getLastOfMonth(DateTime.parse(dateFrom));
    if ((DateTime.parse(dateFrom).day == 1) && (DateTime.parse(dateTo).day == lastDayOfMonth)) {
      return DateFormat('MMMM y').format(DateTime.parse(dateFrom));
    } else {
      if (dateFrom == dateTo) {
        return DateFormat('dd/MM/yyyy').format(DateTime.parse(dateFrom));
      } else {
        return '${DateFormat('dd/MM/yyyy').format(DateTime.parse(dateFrom))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(dateTo))}';
      }
    }
  }

  static int getLastOfMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  static void showLoader(BuildContext context) {
    var alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      content: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white70,
        ),
      ),
    );

    showDialog(context: context, barrierDismissible: true, builder: (_) => alert);
  }

  // ===========================================================================
  static void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
  // ===========================================================================
}
