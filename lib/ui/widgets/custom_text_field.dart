//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool obscure;
  final Function(String val) onChanged;
  final TextEditingController controller;
  final enabled;

  const CustomTextField({
    @required this.hint,
    @required this.obscure,
    @required this.onChanged,
    this.controller,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UIHelper.barHeight,
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscure,
        cursorColor: Colors.black,
        style: Theme.of(context)
            .textTheme
            .bodyText2
            .copyWith(color: enabled ? Colors.black : UIHelper.disabledColor),
        decoration: InputDecoration(
          labelText: hint,
          labelStyle:
              Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).primaryColor),
          border: OutlineInputBorder(
            borderRadius: UIHelper.customBorderRadius,
            borderSide: BorderSide(
              width: 1.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: UIHelper.customBorderRadius,
            borderSide: BorderSide(
              width: 1.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: UIHelper.customBorderRadius,
            borderSide: BorderSide(
              width: 1.0,
              color: UIHelper.disabledColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: UIHelper.customBorderRadius,
            borderSide: BorderSide(
              width: 2.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
