//@dart=2.9

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/helpers/color_cubit.dart';
import 'package:tms_web_app/ui/widgets/custom_icon_button.dart';

class ColorPicker extends StatefulWidget {
  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
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
                  'COLOR:',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(width: 10.0),
                CustomIconButton(
                  icon: Icons.label,
                  iconColor: Color(
                    BlocProvider.of<ColorCubit>(context).state,
                  ),
                  onPressed: _showColorPicker,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showColorPicker() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text('Select a color'),
            content: SingleChildScrollView(
              child: Container(
                width: 200.0,
                height: 300.0,
                child: GridView.builder(
                  itemCount: UIHelper.materialColors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          BlocProvider.of<ColorCubit>(context)
                              .update(UIHelper.materialColors[index]);
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        color: Color(UIHelper.materialColors[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                child: Text(
                  'Cancel',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Theme.of(context).primaryColorDark),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
