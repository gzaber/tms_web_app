//@dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';

void main() {
  StatusCubit sut;
  setUp(() {
    sut = StatusCubit();
  });

  //================================================================================================
  group('initial state', () {
    test('emits default String status when initial state', () {
      expect(sut.state, 'todo');
    });
  });

  //================================================================================================
  group('update', () {
    blocTest<StatusCubit, String>(
      'emits updated [String] status',
      build: () => sut,
      act: (cubit) => cubit.update('done'),
      expect: () => ['done'],
    );
  });

  //================================================================================================
  group('update', () {
    blocTest<StatusCubit, String>(
      'emits default [String] status',
      build: () => sut,
      act: (cubit) => cubit.reset(),
      expect: () => ['todo'],
    );
  });

  //================================================================================================
}
