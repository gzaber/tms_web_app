//@dart=2.9
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Function onPressed;

  const CustomIconButton({@required this.icon, @required this.iconColor, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: IconButton(
            icon: Icon(
              icon,
              size: 20.0,
              color: iconColor,
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
