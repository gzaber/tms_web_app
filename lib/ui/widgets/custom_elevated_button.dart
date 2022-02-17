//@dart=2.9
import 'package:flutter/material.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final void Function() onPressed;

  const CustomElevatedButton({
    @required this.text,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: UIHelper.barHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: UIHelper.customBorderRadius),
          primary: Theme.of(context).primaryColor,
          textStyle: Theme.of(context).textTheme.button,
        ),
        child: Text(text),
        onPressed: onPressed,
      ),
    );
  }
}
