//@dart=2.9

import 'package:flutter_bloc/flutter_bloc.dart';

class MembersCubit extends Cubit<List<String>> {
  MembersCubit() : super([]);

  update(List<String> members) {
    emit(List.of(members));
  }

  reset() {
    emit(List.empty());
  }
}
