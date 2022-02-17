//@dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/state_management/helpers/color_cubit.dart';

void main() {
  ColorCubit sut;
  setUp(() {
    sut = ColorCubit();
  });

  //================================================================================================
  group('initial state', () {
    test('emits default [int] color when initial state', () {
      expect(sut.state, UIHelper.themeColor.value);
    });
  });

  //================================================================================================
  group('update', () {
    blocTest<ColorCubit, int>(
      'emits updated [int] color',
      build: () => sut,
      act: (cubit) => cubit.update(34248),
      expect: () => [isA<int>()],
    );
  });

  //================================================================================================
  group('reset', () {
    blocTest<ColorCubit, int>(
      'emits default [int] color',
      build: () => sut,
      act: (cubit) => cubit.reset(),
      expect: () => [UIHelper.themeColor.value],
    );
  });

  //================================================================================================
}
