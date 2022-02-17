//@dart=2.9

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/models/models.dart';
import 'package:tms_web_app/state_management/settings/settings_cubit.dart';
import 'package:tms_web_app/state_management/settings/settings_state.dart';

void main() {
  SettingsCubit sut;
  setUp(() {
    sut = SettingsCubit();
  });

  //================================================================================================
  group('initial state', () {
    test('emits SettingsInitial() when initial state', () {
      expect(sut.state, SettingsInitial());
    });
  });

  //================================================================================================
  group('showTaskForm', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsLoadInProgress(), SettingsTaskLoadSuccess()]',
      build: () => sut,
      act: (cubit) => cubit.showTaskForm(TaskModel(
          name: 'name',
          description: 'description',
          status: 'status',
          dateFrom: '2021-12-13',
          dateTo: '2021-12-13',
          color: 234234,
          members: ['user'])),
      expect: () => [SettingsLoadInProgress(), isA<SettingsTaskLoadSuccess>()],
    );
  });
  //================================================================================================
  group('showAddTaskForm', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsLoadInProgress(), SettingsTaskLoadSuccess()]',
      build: () => sut,
      act: (cubit) => cubit.showAddTaskForm(),
      expect: () => [SettingsLoadInProgress(), isA<SettingsTaskLoadSuccess>()],
    );
  });
  //================================================================================================
  group('hideForm', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsHideForm()]',
      build: () => sut,
      act: (cubit) => cubit.hideForm(),
      expect: () => [SettingsHideForm()],
    );
  });
  //================================================================================================
  group('showUserForm', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsLoadInProgress(), SettingsUserLoadSuccess()]',
      build: () => sut,
      act: (cubit) => cubit.showUserForm(
          UserModel(id: 'id', username: 'username', email: 'user@email.com', role: 'role')),
      expect: () => [SettingsLoadInProgress(), isA<SettingsUserLoadSuccess>()],
    );
  });
  //================================================================================================
  group('showEmailForm', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsLoadInProgress(), SettingEmailLoadSuccess()]',
      build: () => sut,
      act: (cubit) =>
          cubit.showEmailForm(EmailModel(id: 'id', email: 'user@email.com', role: 'role')),
      expect: () => [SettingsLoadInProgress(), isA<SettingsEmailLoadSuccess>()],
    );
  });
  //================================================================================================
  group('showAddEmailForm', () {
    blocTest<SettingsCubit, SettingsState>(
      'emits [SettingsLoadInProgress(), SettingsEmailLoadSuccess()]',
      build: () => sut,
      act: (cubit) => cubit.showAddEmailForm(),
      expect: () => [SettingsLoadInProgress(), isA<SettingsEmailLoadSuccess>()],
    );
  });
  //================================================================================================
}
