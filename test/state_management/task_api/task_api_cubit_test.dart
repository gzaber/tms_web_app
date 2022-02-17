//@dart=2.9

import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tms_web_app/models/models.dart';
import 'package:tms_web_app/state_management/task_api/task_api_cubit.dart';
import 'package:tms_web_app/state_management/task_api/task_api_state.dart';

import '../fake_api/fake_task_api.dart';

void main() {
  TaskApiCubit sut;
  FakeTaskApi api;

  setUp(() {
    api = FakeTaskApi();
    sut = TaskApiCubit(api);
  });
  //================================================================================================
  group('initial state', () {
    test('emits TaskApiInitial() when initial state', () {
      expect(sut.state, TaskApiInitial());
    });
  });
  //================================================================================================
  group('addTask', () {
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.addTask(
          Token('token'),
          TaskModel(
              name: 'name',
              description: 'description',
              status: 'status',
              dateFrom: '2021-12-12',
              dateTo: '2021-12-12',
              color: 4294924066,
              members: ['user1', 'user2'])),
      expect: () => [TaskApiLoading(), TaskApiActionSuccess("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.addTask(
          Token(''),
          TaskModel(
              name: 'name',
              description: 'description',
              status: 'status',
              dateFrom: '2021-12-12',
              dateTo: '2021-12-12',
              color: 4294924066,
              members: ['user1', 'user2'])),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when empty field',
      build: () => sut,
      act: (cubit) => cubit.addTask(
          Token('token'),
          TaskModel(
              name: '',
              description: 'description',
              status: 'status',
              dateFrom: '2021-12-12',
              dateTo: '2021-12-12',
              color: 4294924066,
              members: ['user1', 'user2'])),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
  });
  //================================================================================================
  group('updateTask', () {
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.updateTask(
          Token('token'),
          TaskModel(
              id: 'id',
              name: 'name',
              description: 'description',
              status: 'status',
              dateFrom: '2021-12-12',
              dateTo: '2021-12-12',
              color: 4294924066,
              members: ['user1', 'user2'])),
      expect: () => [TaskApiLoading(), TaskApiActionSuccess("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when failure',
      build: () => sut,
      act: (cubit) => cubit.updateTask(
          Token('token'),
          TaskModel(
              id: '',
              name: 'name',
              description: 'description',
              status: 'status',
              dateFrom: '2021-12-12',
              dateTo: '2021-12-12',
              color: 4294924066,
              members: ['user1', 'user2'])),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.updateTask(
          Token(''),
          TaskModel(
              id: 'id',
              name: 'name',
              description: 'description',
              status: 'status',
              dateFrom: '2021-12-12',
              dateTo: '2021-12-12',
              color: 4294924066,
              members: ['user1', 'user2'])),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when empty field',
      build: () => sut,
      act: (cubit) => cubit.updateTask(
          Token('token'),
          TaskModel(
              id: 'id',
              name: '',
              description: 'description',
              status: 'status',
              dateFrom: '2021-12-12',
              dateTo: '2021-12-12',
              color: 4294924066,
              members: ['user1', 'user2'])),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
  });
  //================================================================================================
  group('updateTaskStatus', () {
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.updateTaskStatus(Token('token'), 'id', 'todo'),
      expect: () => [TaskApiLoading(), TaskApiActionSuccess("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when failure',
      build: () => sut,
      act: (cubit) => cubit.updateTaskStatus(Token('token'), '', 'todo'),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.updateTaskStatus(Token(''), 'id', 'todo'),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
  });
  //================================================================================================
  group('deleteTask', () {
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.deleteTask(Token('token'), 'id'),
      expect: () => [TaskApiLoading(), TaskApiActionSuccess("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when failure',
      build: () => sut,
      act: (cubit) => cubit.deleteTask(Token('token'), ''),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiActionFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.deleteTask(Token(''), 'id'),
      expect: () => [TaskApiLoading(), TaskApiActionFailure("")],
    );
  });
  //================================================================================================
  group('getAll', () {
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiLoadListSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.getAll(Token('token')),
      expect: () => [TaskApiLoading(), TaskApiLoadListSuccess([])],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiFailure()] when no tasks found',
      setUp: () => api.clearTasks(),
      build: () => sut,
      act: (cubit) => cubit.getAll(Token('token')),
      expect: () => [TaskApiLoading(), TaskApiFailure("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.getAll(Token('')),
      expect: () => [TaskApiLoading(), TaskApiFailure("")],
    );
  });
  //================================================================================================
  group('getByDateRange', () {
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiLoadListSuccess()] when success',
      build: () => sut,
      act: (cubit) => cubit.getByDateRange(Token('token'), '2021-12-12', '2021-12-12'),
      expect: () => [TaskApiLoading(), TaskApiLoadListSuccess([])],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiFailure()] when no tasks found',
      setUp: () => api.clearTasks(),
      build: () => sut,
      act: (cubit) => cubit.getByDateRange(Token('token'), '2021-12-01', '2021-12-02'),
      expect: () => [TaskApiLoading(), TaskApiFailure("")],
    );
    blocTest<TaskApiCubit, TaskApiState>(
      'emits [TaskApiLoading(), TaskApiFailure()] when wrong token',
      build: () => sut,
      act: (cubit) => cubit.getByDateRange(Token(''), '2021-12-12', '2021-12-12'),
      expect: () => [TaskApiLoading(), TaskApiFailure("")],
    );
  });
  //================================================================================================
}
