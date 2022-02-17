//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/responsive.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/helpers/status_cubit.dart';
import 'package:tms_web_app/ui/widgets/custom_radio_row.dart';

class StatusRadioGroup extends StatefulWidget {
  @override
  _StatusRadioGroupState createState() => _StatusRadioGroupState();
}

class _StatusRadioGroupState extends State<StatusRadioGroup> {
  @override
  Widget build(BuildContext context) {
    StatusCubit statusCubit = BlocProvider.of<StatusCubit>(context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: UIHelper.customBorderRadius,
        border: Border.all(color: UIHelper.themeColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'STATUS:',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(width: 15.0),
          Responsive.getTaskStatusGroupLayout(
            context,
            List.generate(
              UIHelper.taskStatusList.length,
              (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: CustomRadioRow(
                    title: UIHelper.taskStatusList[index],
                    value: UIHelper.taskStatusList[index],
                    groupValue: statusCubit.state,
                    onChanged: (value) {
                      setState(() {
                        statusCubit.update(UIHelper.taskStatusList[index]);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
