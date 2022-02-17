//@dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/state_management/helpers/helpers.dart';

void main() {
  MembersCubit sut;
  setUp(() {
    sut = MembersCubit();
  });

  //================================================================================================
  group('initial state', () {
    test('emits default List<String> when initial state', () {
      expect(sut.state, []);
    });
  });

  //================================================================================================
  group('update', () {
    blocTest<MembersCubit, List<String>>(
      'emits updated [List<String>]',
      build: () => sut,
      act: (cubit) => cubit.update(['user1', 'user2']),
      expect: () => [
        ['user1', 'user2']
      ],
    );
  });

  //================================================================================================
  group('reset', () {
    blocTest<MembersCubit, List<String>>(
      'emits default [List<String>]',
      build: () => sut,
      act: (cubit) => cubit.reset(),
      expect: () => [[]],
    );
  });

  //================================================================================================
}
