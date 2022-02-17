//@dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/state_management/helpers/settings_menu_cubit.dart';

void main() {
  SettingsMenuCubit sut;
  setUp(() {
    sut = SettingsMenuCubit();
  });

  //================================================================================================
  group('initial state', () {
    test('emits default String menu item name when initial state', () {
      expect(sut.state, 'TASKS');
    });
  });

  //================================================================================================
  group('update', () {
    blocTest<SettingsMenuCubit, String>(
      'emits updated [String] menu item name',
      build: () => sut,
      act: (cubit) => cubit.update('SETTINGS'),
      expect: () => ['SETTINGS'],
    );
  });

  //================================================================================================
}
