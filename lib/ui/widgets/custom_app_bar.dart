//@dart=2.9

import 'package:flutter/material.dart';
import 'package:tms_web_app/composition_root.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';

class CustomAppBar {
  static Widget show({
    BuildContext context,
    String title,
    String username,
    IconData icon,
    Function onPressed,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: UIHelper.barHeight,
      title: Text(
        title,
        style: Theme.of(context).textTheme.subtitle1.copyWith(
              color: Colors.white,
            ),
      ),
      backgroundColor: UIHelper.themeColor[900],
      actions: [
        Row(
          children: [
            Icon(
              Icons.person,
              size: 20.0,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              username,
              style: Theme.of(context).textTheme.caption.copyWith(
                    color: Colors.white,
                  ),
            ),
          ],
        ),
        SizedBox(width: 16.0),
        IconButton(
          icon: Icon(
            icon,
            size: 20.0,
            color: Colors.white,
          ),
          splashRadius: 20.0,
          onPressed: onPressed,
        ),
        SizedBox(width: 16.0),
        IconButton(
          icon: Icon(
            Icons.logout,
            size: 20.0,
            color: Colors.white,
          ),
          splashRadius: 20.0,
          onPressed: () async {
            UIHelper.showLoader(context);
            await Future.delayed(Duration(milliseconds: 500));
            UIHelper.hideLoader(context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CompositionRoot.composeAuthUI(),
              ),
            );
          },
        ),
        SizedBox(width: 16.0),
      ],
    );
  }
}
