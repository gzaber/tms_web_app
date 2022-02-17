//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/helpers/date_range_cubit.dart';
import 'package:tms_web_app/ui/widgets/custom_icon_button.dart';

class DatePicker extends StatefulWidget {
  final Function onSetDate;

  DatePicker({this.onSetDate});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateRangeCubit dateRangeCubit = BlocProvider.of<DateRangeCubit>(context);
    return Container(
      height: UIHelper.barHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: UIHelper.customBorderRadius,
        border: Border.all(color: UIHelper.themeColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(
                  'DATE:',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(width: 10.0),
                Text(
                  UIHelper.formatTaskTerm(
                    dateRangeCubit.state.dateFrom,
                    dateRangeCubit.state.dateTo,
                  ),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            ),
          ),
          CustomIconButton(
            icon: Icons.date_range,
            iconColor: UIHelper.themeColor,
            onPressed: () async {
              final result = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2050),
              );
              setState(() {
                if (result != null) {
                  dateRangeCubit.update(DateFormat('yyyy-MM-dd').format(result.start),
                      DateFormat('yyyy-MM-dd').format(result.end));
                }
                if (widget.onSetDate != null) {
                  widget.onSetDate();
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
