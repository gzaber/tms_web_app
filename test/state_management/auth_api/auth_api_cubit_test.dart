//@dart=2.9

import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_cubit.dart';
import 'package:tms_web_app/state_management/auth_api/auth_api_state.dart';

import '../fake_api/fake_auth_api.dart';

void main() {
  AuthApiCubit sut;
  FakeAuthApi api;

  setUp(() {
    api = FakeAuthApi();
    sut = AuthApiCubit(api);
  });

  //================================================================================================
  group('initial state', () {
    test('emits AuthApiInitial() when initial state', () {
      expect(sut.state, AuthApiInitial());
    });
  });
  //================================================================================================
  group('register', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiRegisterSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.register('username', 'user@email.com', 'password'),
      expect: () => [AuthApiLoading(), AuthApiRegisterSuccess('id')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when email not allowed',
      build: () => sut,
      act: (cubit) => cubit.register('username', 'notallowed@email.com', 'password'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when wrong email format',
      build: () => sut,
      act: (cubit) => cubit.register('username', 'wrongEmail', 'password'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when empty field',
      build: () => sut,
      act: (cubit) => cubit.register('', 'user@email.com', 'password'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
  });
  //================================================================================================
  group('login', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiLoginSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.login('user@email.com', 'password'),
      expect: () => [AuthApiLoading(), isA<AuthApiLoginSuccess>()],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when unknown email',
      build: () => sut,
      act: (cubit) => cubit.login('unknown@email.com', 'password'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when wrong password',
      build: () => sut,
      act: (cubit) => cubit.login('user@email.com', 'wrongpass'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when wrong email format',
      build: () => sut,
      act: (cubit) => cubit.login('wrongEmail', 'password'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when empty field',
      build: () => sut,
      act: (cubit) => cubit.login('', 'password'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
  });
  //================================================================================================
  group('forgotPassword', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiForgotPasswordSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.forgotPassword('user@email.com'),
      expect: () => [AuthApiLoading(), AuthApiForgotPasswordSuccess('id')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when unknown email',
      build: () => sut,
      act: (cubit) => cubit.forgotPassword('unknown@email.com'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when wrong email format',
      build: () => sut,
      act: (cubit) => cubit.forgotPassword('wrongEmail'),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when empty field',
      build: () => sut,
      act: (cubit) => cubit.forgotPassword(''),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
  });
  //================================================================================================
  //================================================================================================
  group('addEmail', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.addEmail(Token('token'), 'user@email.com', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionSuccess('success')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.addEmail(Token(''), 'user@email.com', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong email format',
      build: () => sut,
      act: (cubit) => cubit.addEmail(Token('token'), 'wrongEmailFormat', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when empty field',
      build: () => sut,
      act: (cubit) => cubit.addEmail(Token('token'), '', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
  });
  //================================================================================================
  group('updateEmail', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.updateEmail(Token('token'), 'id', 'user@email.com', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionSuccess('success')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.updateEmail(Token(''), 'id', 'user@email.com', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong id',
      build: () => sut,
      act: (cubit) => cubit.updateEmail(Token('token'), '', 'user@email.com', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong email format',
      build: () => sut,
      act: (cubit) => cubit.updateEmail(Token('token'), 'id', 'wrongEmailFormat', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when empty field',
      build: () => sut,
      act: (cubit) => cubit.updateEmail(Token('token'), 'id', '', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
  });
  //================================================================================================
  group('deleteEmail', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.deleteEmail(Token('token'), 'id'),
      expect: () => [AuthApiLoading(), AuthApiActionSuccess('success')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.deleteEmail(Token(''), 'id'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong id',
      build: () => sut,
      act: (cubit) => cubit.deleteEmail(Token('token'), ''),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
  });
  //================================================================================================
  group('getAllEmails', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiLoadEmailListSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.getAllEmails(Token('token')),
      expect: () => [AuthApiLoading(), isA<AuthApiLoadEmailListSuccess>()],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when no emails found',
      setUp: () => api.clearEmails(),
      build: () => sut,
      act: (cubit) => cubit.getAllEmails(Token('token')),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.getAllEmails(Token('')),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
  });
  //================================================================================================
  //================================================================================================
  group('updateUserName', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.updateUserName(Token('token'), 'id', 'username'),
      expect: () => [AuthApiLoading(), AuthApiActionSuccess('success')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.updateUserName(Token(''), 'id', 'username'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong id',
      build: () => sut,
      act: (cubit) => cubit.updateUserName(Token('token'), '', 'username'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when empty field',
      build: () => sut,
      act: (cubit) => cubit.updateUserName(Token('token'), 'id', ''),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
  });
  //================================================================================================

  group('updateUserPassword', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.updateUserPassword(
          Token('token'), 'id', 'oldPassword', 'newPassword', 'newPassword'),
      expect: () => [AuthApiLoading(), AuthApiActionSuccess('success')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) =>
          cubit.updateUserPassword(Token(''), 'id', 'oldPassword', 'newPassword', 'newPassword'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong id',
      build: () => sut,
      act: (cubit) =>
          cubit.updateUserPassword(Token('token'), '', 'oldPassword', 'newPassword', 'newPassword'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when empty field',
      build: () => sut,
      act: (cubit) =>
          cubit.updateUserPassword(Token('token'), 'id', '', 'newPassword', 'newPassword'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong old password',
      build: () => sut,
      act: (cubit) => cubit.updateUserPassword(
          Token('token'), 'id', 'wrongOldPassword', 'newPassword', 'newPassword'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when new password mismatch',
      build: () => sut,
      act: (cubit) => cubit.updateUserPassword(
          Token('token'), 'id', 'oldPassword', 'newPassword1', 'newPassword'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
  });
  //================================================================================================
  group('updateUserRole', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.updateUserRole(Token('token'), 'id', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionSuccess('success')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.updateUserRole(Token(''), 'id', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong id',
      build: () => sut,
      act: (cubit) => cubit.updateUserRole(Token('token'), '', 'role'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
  });
  //================================================================================================
  group('deleteUser', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.deleteUser(Token('token'), 'id'),
      expect: () => [AuthApiLoading(), AuthApiActionSuccess('success')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.deleteUser(Token(''), 'id'),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiActionFailure()] when wrong id',
      build: () => sut,
      act: (cubit) => cubit.deleteUser(Token('token'), ''),
      expect: () => [AuthApiLoading(), AuthApiActionFailure('error')],
    );
  });
  //================================================================================================
  group('getAllUsers', () {
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiLoadUserListSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.getAllUsers(Token('token')),
      expect: () => [AuthApiLoading(), isA<AuthApiLoadUserListSuccess>()],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when no users found',
      setUp: () => api.clearUsers(),
      build: () => sut,
      act: (cubit) => cubit.getAllUsers(Token('token')),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
    blocTest<AuthApiCubit, AuthApiState>(
      'emits [AuthApiLoading(), AuthApiFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.getAllUsers(Token('')),
      expect: () => [AuthApiLoading(), AuthApiFailure('error')],
    );
  });
  //================================================================================================
}
