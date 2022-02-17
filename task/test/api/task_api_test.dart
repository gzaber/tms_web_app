//@dart=2.9
import 'dart:convert';

import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:task/src/api/task_api.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient client;
  TaskApi sut;
  Token token = new Token('token');
  setUp(() {
    client = MockClient();
    sut = TaskApi('http:baseUrl', client);
  });

  // ===============================================================================================
  group('add', () {
    test('should return id when success', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.add(
          token: token,
          name: 'taskName',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.add(
          token: token,
          name: 'taskName',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.add(
          token: Token('wrongToken'),
          name: 'taskName',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
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
      final result = await sut.add(
          token: token,
          name: '',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('update', () {
    test('should return id when success', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.update(
          token: token,
          id: 'someId',
          name: 'taskName',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.update(
          token: token,
          id: 'wrongId',
          name: 'taskName',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.update(
          token: token,
          id: 'someId',
          name: 'taskName',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.update(
          token: Token('wrongToken'),
          id: 'someId',
          name: 'taskName',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
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
      final result = await sut.update(
          token: token,
          id: 'someId',
          name: '',
          description: 'taskDescription',
          dateFrom: '2021-12-06',
          dateTo: '2021-12-07',
          status: 'todo',
          color: 4294951175,
          members: ['User1', 'User2']);
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('updateTaskStatus', () {
    test('should return id when success', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.updateTaskStatus(token, 'someId', 'during');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.updateTaskStatus(token, 'wrongId', 'during');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.updateTaskStatus(token, 'someId', 'during');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.put(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.updateTaskStatus(Token('wrongToken'), 'someId', 'during');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('delete', () {
    test('should return id when success', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'id': 'someId'}), 200));
      // act
      final result = await sut.delete(token, 'someId');
      // assert
      expect(result.asValue.value, 'someId');
    });
    test('should return error when failure', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'failure'}), 404));
      // act
      final result = await sut.delete(token, 'wrongId');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'))).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.delete(token, 'someId');
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.delete(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.delete(Token('wrongToken'), 'someId');
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('getAllTasks', () {
    test('should return list of tasks when success', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(
          jsonEncode({
            'tasks': [
              {
                "id": "taskId",
                "name": "task name",
                "description": "task description",
                "status": "todo",
                "dateFrom": "2021-11-06",
                "dateTo": "2021-11-06",
                "color": 4294951175,
                "members": ["User1", "User2"]
              }
            ]
          }),
          200));
      // act
      final result = await sut.getAllTasks(token);
      // assert
      expect(result.asValue.value.length, 1);
      expect(result.asValue.value[0].id, 'taskId');
    });
    test('should return error when no tasks found', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'no tasks found'}), 404));
      // act
      final result = await sut.getAllTasks(token);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.get(any)).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.getAllTasks(token);
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.getAllTasks(Token('wrongToken'));
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
  group('getTasksByDateRange', () {
    test('should return list of tasks when success', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers'))).thenAnswer((_) async => http.Response(
          jsonEncode({
            'tasks': [
              {
                "id": "taskId",
                "name": "task name",
                "description": "task description",
                "status": "todo",
                "dateFrom": "2021-11-06",
                "dateTo": "2021-11-07",
                "color": 4294951175,
                "members": ["User1", "User2"]
              }
            ]
          }),
          200));
      // act
      final result = await sut.getTasksByDateRange(token, "2021-11-06", "2021-11-07");
      // assert
      expect(result.asValue.value.length, 1);
      expect(result.asValue.value[0].id, 'taskId');
    });
    test('should return error when no tasks found', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'no tasks found'}), 404));
      // act
      final result = await sut.getTasksByDateRange(token, "2021-11-01", "2021-11-02");
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when no authorization header', () async {
      // arrange
      when(client.get(any)).thenAnswer(
          (_) async => http.Response(jsonEncode({'error': 'authorization header error'}), 401));
      // act
      final result = await sut.getTasksByDateRange(token, "2021-11-06", "2021-11-07");
      // assert
      expect(result, isA<ErrorResult>());
    });
    test('should return error when unauthorized', () async {
      // arrange
      when(client.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(jsonEncode({'error': 'unauthorized'}), 403));
      // act
      final result = await sut.getTasksByDateRange(Token('wrongToken'), "2021-11-06", "2021-11-07");
      // assert
      expect(result, isA<ErrorResult>());
    });
  });
  // ===============================================================================================
}
