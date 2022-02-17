//@dart=2.9
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';

class DaysOfMonthList extends StatelessWidget {
  final DateTime date;

  const DaysOfMonthList({
    @required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: getDaysInMonth(date)
            .map(
              (item) => Flexible(
                fit: FlexFit.tight,
                child: Container(
                  alignment: Alignment.centerRight,
                  width: Responsive.getDaysListWidth(context),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  margin: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 2.0),
                  child: Text(
                    item,
                    style: (item.contains('Sat') || item.contains('Sun')
                        ? Theme.of(context).textTheme.bodyText1.copyWith(
                              color: Colors.white,
                              fontSize: Responsive.getScheduleFontSize(context),
                            )
                        : Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: Responsive.getScheduleFontSize(context),
                            )),
                  ),
                  decoration: BoxDecoration(
                    color: item.contains('Sun')
                        ? UIHelper.themeColor[400]
                        : (item.contains('Sat')
                            ? UIHelper.themeColor[300]
                            : UIHelper.themeColor[100]),
                    borderRadius: UIHelper.customBorderRadius,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<String> getDaysInMonth(DateTime date) {
    List<String> days = [];
    var lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      days.add(DateFormat('d E').format(DateTime(date.year, date.month, i)));
    }
    return days;
  }
}
