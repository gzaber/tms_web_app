//@dart=2.9
import 'package:flutter/material.dart';

class Responsive {
  static double getDaysListWidth(BuildContext context) {
    return (MediaQuery.of(context).size.height > 800.0 &&
            MediaQuery.of(context).size.width > 1200.0)
        ? 100.0
        : 70.0;
  }

  static double getSideTaskListWidth(BuildContext context) {
    return (MediaQuery.of(context).size.height > 800.0 &&
            MediaQuery.of(context).size.width > 1200.0)
        ? 200.0
        : 100.0;
  }

  static double getScheduleFontSize(BuildContext context) {
    return (MediaQuery.of(context).size.height > 800.0 &&
            MediaQuery.of(context).size.width > 1200.0)
        ? 14.0
        : 12.0;
  }

  static double getAuthViewWidth(BuildContext context) {
    return (MediaQuery.of(context).size.width > 500.0) ? 400.0 : double.infinity;
  }

  static Widget getSettingsLayout(BuildContext context, Widget widgetA, Widget widgetB) {
    return (MediaQuery.of(context).size.width > 1000.0)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [widgetA, widgetB],
          )
        : Column(
            children: [widgetA, widgetB],
          );
  }

  static double getSettingsMenuWidth(BuildContext context) {
    return (MediaQuery.of(context).size.width > 1000.0) ? 150.0 : double.infinity;
  }

  static Axis getSettingsMenuDirection(BuildContext context) {
    return (MediaQuery.of(context).size.width > 1000.0) ? Axis.vertical : Axis.horizontal;
  }

  static double getSettingsPadding(BuildContext context) {
    return (MediaQuery.of(context).size.width > 1000.0) ? 0.0 : 5.0;
  }

  static double getSettingsSizedBoxWidth(BuildContext context) {
    return (MediaQuery.of(context).size.width > 1000.0) ? 5.0 : 0.0;
  }

  static int getSettingsFlex(BuildContext context) {
    return (MediaQuery.of(context).size.width > 1000.0) ? 1 : 0;
  }

  static bool isLargeScreen(BuildContext context) {
    return (MediaQuery.of(context).size.width > 1000.0) ? true : false;
  }

  static Widget getTaskStatusGroupLayout(BuildContext context, List<Widget> widgets) {
    return (MediaQuery.of(context).size.width > 1000.0)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widgets,
          );
  }
}
