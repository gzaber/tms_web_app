//@dart=2.9

import 'package:flutter_bloc/flutter_bloc.dart';

class RoleCubit extends Cubit<String> {
  RoleCubit() : super('');

  update(String role) {
    emit(role);
  }
}
