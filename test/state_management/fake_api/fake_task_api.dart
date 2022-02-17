//@dart=2.9

import 'package:auth/src/domain/token.dart';
import 'package:async/src/result/result.dart';
import 'package:task/task.dart';
import 'package:tms_web_app/models/models.dart';

class FakeTaskApi implements ITaskApi {
  List<TaskModel> tasks = [];

  FakeTaskApi() {
    tasks = [
      TaskModel(
          name: 'name1',
          description: 'description1',
          status: 'todo',
          dateFrom: '2021-12-10',
          dateTo: '2021-12-10',
          color: 23253434,
          members: ['user1']),
      TaskModel(
          name: 'name2',
          description: 'description2',
          status: 'todo',
          dateFrom: '2021-12-12',
          dateTo: '2021-12-12',
          color: 23253434,
          members: ['user1', 'user2']),
    ];
  }

  void clearTasks() {
    tasks = [];
  }

  //================================================================================================
  @override
  Future<Result<String>> add(
      {Token token,
      String name,
      String description,
      String dateFrom,
      String dateTo,
      String status,
      int color,
      List<String> members}) async {
    if (token.value.isEmpty || name.isEmpty || description.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  //================================================================================================
  @override
  Future<Result<String>> update(
      {Token token,
      String id,
      String name,
      String description,
      String dateFrom,
      String dateTo,
      String status,
      int color,
      List<String> members}) async {
    if (token.value.isEmpty || id.isEmpty || name.isEmpty || description.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  //================================================================================================
  @override
  Future<Result<String>> updateTaskStatus(Token token, String id, String status) async {
    if (token.value.isEmpty || id.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  //================================================================================================
  @override
  Future<Result<String>> delete(Token token, String id) async {
    if (token.value.isEmpty || id.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  //================================================================================================
  @override
  Future<Result<List<Task>>> getAllTasks(Token token) async {
    if (token.value.isEmpty || tasks.isEmpty)
      return Result.error('error');
    else
      return Result.value([
        Task(
            id: 'id',
            name: 'name',
            description: 'description',
            status: 'status',
            dateFrom: '2021-12-12',
            dateTo: '2021-12-12',
            color: 4534534545,
            members: ['user1', 'user2'])
      ]);
  }

  //================================================================================================
  @override
  Future<Result<List<Task>>> getTasksByDateRange(
      Token token, String dateFrom, String dateTo) async {
    if (token.value.isEmpty || tasks.isEmpty)
      return Result.error('error');
    else
      return Result.value([
        Task(
            id: 'id',
            name: 'name',
            description: 'description',
            status: 'status',
            dateFrom: '2021-12-12',
            dateTo: '2021-12-12',
            color: 4534534545,
            members: ['user1', 'user2'])
      ]);
  }

  //================================================================================================
}
