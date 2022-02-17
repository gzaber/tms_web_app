//@dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/models/date_range.dart';
import 'package:tms_web_app/state_management/helpers/date_range_cubit.dart';

void main() {
  DateRangeCubit sut;
  setUp(() {
    sut = DateRangeCubit();
  });

  //================================================================================================
  group('initial state', () {
    test('emits default DateRange when initial state', () {
      expect(sut.state, isA<DateRange>());
    });
  });

  //================================================================================================
  group('update', () {
    blocTest<DateRangeCubit, DateRange>(
      'emits updated [DateRange]',
      build: () => sut,
      act: (cubit) => cubit.update('2021-12-12', '2021-12-13'),
      expect: () => [isA<DateRange>()],
    );
  });

  //================================================================================================
  group('reset', () {
    blocTest<DateRangeCubit, DateRange>(
      'emits default [DateRange]',
      build: () => sut,
      act: (cubit) => cubit.reset(),
      expect: () => [isA<DateRange>()],
    );
  });

  //================================================================================================
}
