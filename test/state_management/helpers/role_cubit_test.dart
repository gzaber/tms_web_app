//@dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';

void main() {
  RoleCubit sut;
  setUp(() {
    sut = RoleCubit();
  });

  //================================================================================================
  group('initial state', () {
    test('emits default String role when initial state', () {
      expect(sut.state, '');
    });
  });

  //================================================================================================
  group('update', () {
    blocTest<RoleCubit, String>(
      'emits updated [String] role',
      build: () => sut,
      act: (cubit) => cubit.update('role'),
      expect: () => ['role'],
    );
  });

  //================================================================================================
}
