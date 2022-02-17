//@dart=2.9

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';

class ColorCubit extends Cubit<int> {
  ColorCubit() : super(UIHelper.themeColor.value);

  update(int color) {
    emit(color);
  }

  reset() {
    emit(UIHelper.themeColor.value);
  }
}
