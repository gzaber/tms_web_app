//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/helpers/role_cubit.dart';
import 'package:tms_web_app/ui/widgets/custom_radio_row.dart';

class RoleRadioGroup extends StatefulWidget {
  @override
  _RoleRadioGroupState createState() => _RoleRadioGroupState();
}

class _RoleRadioGroupState extends State<RoleRadioGroup> {
  String role = 'admin';

  @override
  Widget build(BuildContext context) {
    RoleCubit roleCubit = BlocProvider.of<RoleCubit>(context);
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
            'ROLE:',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(width: 15.0),
          Row(
            children: List.generate(
              UIHelper.userRoleList.length,
              (index) {
                return CustomRadioRow(
                  title: UIHelper.userRoleList[index],
                  value: UIHelper.userRoleList[index],
                  groupValue: roleCubit.state,
                  onChanged: (value) {
                    setState(() {
                      roleCubit.update(UIHelper.userRoleList[index]);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
