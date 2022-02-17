// @dart=2.9
import 'dart:convert';

import 'package:auth/auth.dart';
import 'package:auth/src/domain/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient client;
  AuthApi sut;
  Token token = new Token('token');
  setUp(() {
    client = MockClient();
    sut = AuthApi('http:baseUrl', client);
  });
  // ===============================================================================================
  group('register', () {
    test('should return user id when success', () async {
      // arrange
      String id = 'someId';
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': id}), 200));
      // act
      final result = await sut.register('username', 'user@email.com', 'password');
      // assert
      expect(result.asValue.value, id);
    });
    test('should return error when failure', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.register('username', 'unknown@email.com', 'password');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when empty field', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'empty field'}
                ]
              }),
              422));
      // act
      final result = await sut.register('', 'user@email.com', 'password');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when wrong email format', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'wrong email format'}
                ]
              }),
              422));
      // act
      final result = await sut.register('username', 'wrongEmail', 'password');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('login', () {
    test('should return token when success', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'token': token.value}), 200));
      // act
      final result = await sut.login('user@email.com', 'password');
      // assert
      expect(result.asValue.value.value, token.value);
    });
    test('should return error when failure', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.login('unknown@email.com', 'password');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when empty field', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'empty field'}
                ]
              }),
              422));
      // act
      final result = await sut.login('user@email.com', '');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when wrong email format', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'wrong email format'}
                ]
              }),
              422));
      // act
      final result = await sut.login('wrongEmail', 'password');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('forgotPassword', () {
    test('should return user id when success', () async {
      // arrange
      String id = 'someId';
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': id}), 200));
      // act
      final result = await sut.forgotPassword('user@email.com');
      // assert
      expect(result.asValue.value, id);
    });
    test('should return error when failure', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.forgotPassword('unknown@email.com');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when wrong email format', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'wrong email format'}
                ]
              }),
              422));
      // act
      final result = await sut.forgotPassword('wrongEmail');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('findUser', () {
    test('should return user when success', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(
          jsonEncode({
            "id": 'userId',
            "username": 'username',
            "email": 'user@mail.com',
            "role": 'user',
            "isConfirmed": true
          }),
          200));
      // act
      final result = await sut.findUser('user@mail.com');
      // assert
      expect(result.asValue.value, isA<User>());
      expect(result.asValue.value.id, 'userId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.findUser('unknown@email.com');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when wrong email format', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(
          jsonEncode({
            'errors': [
              {'wrong email format'}
            ]
          }),
          422));
      // act
      final result = await sut.findUser('wrongEmail');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('addEmail', () {
    test('should return email id when success', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.addEmail(token, 'user@email.com', 'role');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.addEmail(token, 'user@email.com', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.addEmail(new Token('wrongToken'), 'user@email.com', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when empty field', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'empty field'}
                ]
              }),
              422));
      // act
      final result = await sut.addEmail(token, 'user@email.com', '');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when wrong email format', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'wrong email format'}
                ]
              }),
              422));
      // act
      final result = await sut.addEmail(token, 'wrongEmail', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('updateEmail', () {
    test('should return email id when success', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.updateEmail(token, 'someId', 'user@email.com', 'role');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.updateEmail(token, 'wrongId', 'user@email.com', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.updateEmail(token, 'someId', 'user@email.com', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result =
          await sut.updateEmail(new Token('wrongToken'), 'someId', 'user@email.com', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when empty field', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'empty field'}
                ]
              }),
              422));
      // act
      final result = await sut.updateEmail(token, 'someId', 'user@email.com', '');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when wrong email format', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'wrong email format'}
                ]
              }),
              422));
      // act
      final result = await sut.updateEmail(token, 'someId', 'wrongEmail', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('deleteEmail', () {
    test('should return email id when success', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.deleteEmail(token, 'someId');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.deleteEmail(token, 'wrongId');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.deleteEmail(token, 'someId');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.deleteEmail(new Token('wrongToken'), 'someId');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('getAllEmails', () {
    test('should return list of emails when success', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(
          jsonEncode({
            "emails": [
              {
                "id": 'emailId',
                "email": 'user@mail.com',
                "role": 'user',
              }
            ]
          }),
          200));
      // act
      final result = await sut.getAllEmails(token);
      // assert
      expect(result.asValue.value.length, 1);
      expect(result.asValue.value[0].id, 'emailId');
    });
    test('should return error when no emails found', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'no emails found'}), 404));
      // act
      final result = await sut.getAllEmails(token);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.get(any)).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.getAllEmails(token);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.getAllEmails(new Token('wrongToken'));
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('updateUserName', () {
    test('should return user id when success', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.updateUserName(token, 'someId', 'username');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.updateUserName(token, 'wrongId', 'username');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.updateUserName(token, 'someId', 'username');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.updateUserName(new Token('wrongToken'), 'someId', 'username');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when empty field', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'empty field'}
                ]
              }),
              422));
      // act
      final result = await sut.updateUserName(token, 'someId', '');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('updateUserPassword', () {
    test('should return user id when success', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.updateUserPassword(
          token, 'someId', 'oldPassword', 'newPassword', 'newPassword');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.updateUserPassword(
          token, 'wrongId', 'oldPassword', 'newPassword', 'newPassword');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header'}), 401));
      // act
      final result = await sut.updateUserPassword(
          token, 'someId', 'oldPassword', 'newPassword', 'newPassword');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.updateUserPassword(
          new Token('wrongToken'), 'someId', 'oldPassword', 'newPassword', 'newPassword');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return errors when empty field', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({
                'errors': [
                  {'empty field'}
                ]
              }),
              422));
      // act
      final result =
          await sut.updateUserPassword(token, 'someId', '', 'newPassword', 'newPassword');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('updateUserRole', () {
    test('should return user id when success', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.updateUserRole(token, 'someId', 'role');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.updateUserRole(token, 'wrongId', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header'}), 401));
      // act
      final result = await sut.updateUserRole(token, 'someId', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.updateUserRole(new Token('wrongToken'), 'someId', 'role');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('deleteUser', () {
    test('should return email id when success', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.deleteUser(token, 'someId');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.deleteUser(token, 'wrongId');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header'}), 401));
      // act
      final result = await sut.deleteUser(token, 'someId');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.deleteUser(new Token('wrongToken'), 'someId');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('getAllUsers', () {
    test('should return list of emails when success', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(
          jsonEncode({
            "users": [
              {
                "id": 'userId',
                "username": 'username',
                "email": 'user@mail.com',
                "role": 'user',
                "isConfirmed": true
              }
            ]
          }),
          200));
      // act
      final result = await sut.getAllUsers(token);
      // assert
      expect(result.asValue.value.length, 1);
      expect(result.asValue.value[0].id, 'userId');
    });
    test('should return error when no users found', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'no users found'}), 404));
      // act
      final result = await sut.getAllUsers(token);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.get(any)).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.getAllUsers(token);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.getAllUsers(new Token('wrongToken'));
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
}
