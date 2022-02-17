//@dart=2.9

import 'package:auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:task/src/api/task_api.dart';

import '../helpers.dart';

final Map<String, dynamic> emailJSON = {"email": 'admin@mail.com', "role": 'admin'};

final Map<String, dynamic> userJSON = {
  "username": 'Admin',
  "email": 'admin@mail.com',
  "password": "\$2a\$10\$IsQjY7jvQihAYoY6RvYcNO7vv5SA4p2yI5oWKoNIWLAVxQIMWA35a",
  "role": 'admin',
  "isConfirmed": true
};

final List<Map<String, dynamic>> tasksJSON = [
  {
    "name": "taskName1",
    "description": "taskDescription1",
    "status": "todo",
    "dateFrom": DateTime.parse("2021-12-06"),
    "dateTo": DateTime.parse("2021-12-07"),
    "color": 4294951175,
    "members": ["User1", "User2"]
  },
  {
    "name": "taskName2",
    "description": "taskDescription2",
    "status": "todo",
    "dateFrom": DateTime.parse("2021-12-10"),
    "dateTo": DateTime.parse("2021-12-10"),
    "color": 4294951175,
    "members": ["User1", "User2"]
  }
];

void main() {
  http.Client client;
  String baseUrl;
  AuthApi authApi;
  TaskApi sut;
  Db db;
  DbCollection emailCollection;
  DbCollection userCollection;
  DbCollection taskCollection;
  List<Map<String, dynamic>> tasks;

  setUpAll(() async {
    baseUrl = API_URL;
    db = await Db.create(MONGO_URL);
    await db.open();
  });
  setUp(() async {
    client = http.Client();
    authApi = AuthApi(baseUrl, client);
    sut = TaskApi(baseUrl, client);

    emailCollection = db.collection('emails');
    userCollection = db.collection('users');
    taskCollection = db.collection('tasks');
    await emailCollection.insert(emailJSON);
    await userCollection.insert(userJSON);
    await taskCollection.insertMany(tasksJSON);
    tasks = await taskCollection.find().toList();
  });
  tearDown(() async {
    await db.dropCollection('emails');
    await db.dropCollection('users');
    await db.dropCollection('tasks');
  });
  tearDownAll(() async {
    await db.close();
  });

  // ===========================================================================
  group('add', () {
    Token token;
    setUp(() async {
      var result = await authApi.login(userJSON['email'], 'password');
      token = result.asValue.value;
    });
    test('should return task id when success', () async {
      // act
      var result = await sut.add(
        token: token,
        name: 'taskName',
        description: 'taskDescription',
        dateFrom: '2021-11-10',
        dateTo: '2021-11-11',
        status: 'todo',
        color: 4288423856,
        members: ['UserX', 'UserY'],
      );
      // assert
      expect(result.asValue.value, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.add(
        token: Token('wrongToken'),
        name: 'taskName',
        description: 'taskDescription',
        dateFrom: '2021-11-10',
        dateTo: '2021-11-11',
        status: 'todo',
        color: 4288423856,
        members: ['UserX', 'UserY'],
      );
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when empty field', () async {
      // act
      var result = await sut.add(
        token: token,
        name: '',
        description: 'taskDescription',
        dateFrom: '2021-11-10',
        dateTo: '2021-11-11',
        status: 'todo',
        color: 4288423856,
        members: ['UserX', 'UserY'],
      );
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===========================================================================
  group('update', () {
    Token token;
    setUp(() async {
      var result = await authApi.login(userJSON['email'], 'password');
      token = result.asValue.value;
    });
    test('should return task id when success', () async {
      // act
      var result = await sut.update(
        token: token,
        id: tasks[0]["_id"].toHexString(),
        name: 'taskName',
        description: 'taskDescription',
        dateFrom: '2021-11-10',
        dateTo: '2021-11-11',
        status: 'todo',
        color: 4288423856,
        members: ['UserX', 'UserY'],
      );
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value, tasks[0]["_id"].toHexString());
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.update(
        token: token,
        id: 'wrongId',
        name: 'taskName',
        description: 'taskDescription',
        dateFrom: '2021-11-10',
        dateTo: '2021-11-11',
        status: 'todo',
        color: 4288423856,
        members: ['UserX', 'UserY'],
      );
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.update(
        token: Token('wrongToken'),
        id: tasks[0]["_id"].toHexString(),
        name: 'taskName',
        description: 'taskDescription',
        dateFrom: '2021-11-10',
        dateTo: '2021-11-11',
        status: 'todo',
        color: 4288423856,
        members: ['UserX', 'UserY'],
      );
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when empty field', () async {
      // act
      var result = await sut.update(
        token: token,
        id: tasks[0]["_id"].toHexString(),
        name: '',
        description: 'taskDescription',
        dateFrom: '2021-11-10',
        dateTo: '2021-11-11',
        status: 'todo',
        color: 4288423856,
        members: ['UserX', 'UserY'],
      );
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===========================================================================
  group('updateTaskStatus', () {
    Token token;
    setUp(() async {
      var result = await authApi.login(userJSON['email'], 'password');
      token = result.asValue.value;
    });
    test('should return task id when success', () async {
      // act
      var result = await sut.updateTaskStatus(token, tasks[0]["_id"].toHexString(), 'during');
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value, tasks[0]["_id"].toHexString());
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.updateTaskStatus(token, 'wrongId', 'during');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result =
          await sut.updateTaskStatus(Token('wrongToken'), tasks[0]["_id"].toHexString(), 'during');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===========================================================================
  group('delete', () {
    Token token;
    setUp(() async {
      var result = await authApi.login(userJSON['email'], 'password');
      token = result.asValue.value;
    });
    test('should return task id when success', () async {
      // act
      var result = await sut.delete(token, tasks[0]["_id"].toHexString());
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value, tasks[0]["_id"].toHexString());
    });
    test('should return error when failure', () async {
      // act
      var result = await sut.delete(token, 'wrongId');
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.delete(Token('wrongToken'), tasks[0]["_id"].toHexString());
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===========================================================================
  group('getAllTasks', () {
    Token token;
    setUp(() async {
      var result = await authApi.login(userJSON['email'], 'password');
      token = result.asValue.value;
    });
    test('should return list of tasks when success', () async {
      // act
      var result = await sut.getAllTasks(token);
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value.length, tasks.length);
    });
    test('should return error when no tasks found', () async {
      // arrange
      await db.dropCollection('tasks');
      // act
      var result = await sut.getAllTasks(token);
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.getAllTasks(Token('wrongToken'));
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===========================================================================
  group('getTasksByDateRange', () {
    Token token;
    setUp(() async {
      var result = await authApi.login(userJSON['email'], 'password');
      token = result.asValue.value;
    });
    test('should return list of tasks when success', () async {
      // act
      var result = await sut.getTasksByDateRange(token, "2021-12-06", "2021-12-10");
      // assert
      expect(result.asValue.value, isNotEmpty);
      expect(result.asValue.value.length, 2);
    });
    test('should return error when no tasks found', () async {
      // arrange
      await db.dropCollection('tasks');
      // act
      var result = await sut.getTasksByDateRange(token, "2010-12-06", "2010-12-06");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
    test('should return error when wrong token', () async {
      // act
      var result = await sut.getTasksByDateRange(Token('wrongToken'), "2021-12-06", "2021-12-10");
      // assert
      expect(result.asError.error, isNotEmpty);
    });
  });
  // ===========================================================================
}
