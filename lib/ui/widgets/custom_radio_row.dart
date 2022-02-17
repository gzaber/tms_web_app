//@dart=2.9
import 'package:flutter/material.dart';

class CustomRadioRow<T> extends StatelessWidget {
  final String title;
  final T value;
  final T groupValue;
  final Function(T value) onChanged;

  CustomRadioRow(
      {@required this.title,
      @required this.groupValue,
      @required this.value,
      @required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        SizedBox(width: 5.0),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ],
    );
  }
}
