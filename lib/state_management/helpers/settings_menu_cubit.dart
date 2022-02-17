//@dart=2.9

import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsMenuCubit extends Cubit<String> {
  SettingsMenuCubit() : super('TASKS');

  update(String menuItem) {
    emit(menuItem);
  }
}
