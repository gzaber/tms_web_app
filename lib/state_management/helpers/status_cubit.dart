//@dart=2.9

import 'package:flutter_bloc/flutter_bloc.dart';

class StatusCubit extends Cubit<String> {
  StatusCubit() : super('todo');

  update(String role) {
    emit(role);
  }

  reset() {
    emit('todo');
  }
}
