//@dart=2.9

import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/models/auth_data.dart';
import 'package:tms_web_app/state_management/helpers/auth_data_cubit.dart';

void main() {
  AuthDataCubit sut;
  setUp(() {
    sut = AuthDataCubit();
  });

  //================================================================================================
  group('initial state', () {
    test('emits default [AuthData] when initial state', () {
      expect(sut.state, isA<AuthData>());
    });
  });

  //================================================================================================
  group('update', () {
    blocTest<AuthDataCubit, AuthData>(
      'emits updated [AuthData]',
      build: () => sut,
      act: (cubit) => cubit.update(
          token: Token('token'),
          id: 'id',
          username: 'username',
          email: 'user@email.com',
          role: 'user'),
      expect: () => [isA<AuthData>()],
    );
  });

  //================================================================================================
}
