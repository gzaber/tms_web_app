//@dart=2.9

import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/models/auth_data.dart';

class AuthDataCubit extends Cubit<AuthData> {
  AuthDataCubit()
      : super(
          AuthData(
            id: '',
            username: '',
            email: '',
            role: '',
            token: Token(''),
          ),
        );

  update({
    String id,
    String username,
    String email,
    String role,
    Token token,
  }) {
    emit(AuthData(
      id: id,
      username: username,
      email: email,
      role: role,
      token: token,
    ));
  }
}
