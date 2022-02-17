//@dart=2.9
import 'dart:convert';

import 'package:async/async.dart';
import 'package:auth/auth.dart';
import 'package:task/src/domain/api/i_task_api.dart';
import 'package:task/src/domain/task.dart';

import 'package:http/http.dart' as http;

class TaskApi implements ITaskApi {
  final http.Client _client;
  final String baseUrl;

  TaskApi(this.baseUrl, this._client);
  // ===========================================================================
  _transformError(Map map) {
    var contents = map['error'] ?? map['errors'];
    if (contents is String) return contents;
    var errStr = contents.fold('', (prev, ele) => prev + ele.values.first + '\n');
    return errStr.trim();
  }

  _getTaskMembers(List taskMembers) {
    List<String> _members = [];
    if (taskMembers.isEmpty) return _members;
    for (var member in taskMembers) {
      _members.add(member);
    }
    return _members;
  }

  // ===========================================================================
  // ===========================================================================

  @override
  Future<Result<String>> add({
    Token token,
    String name,
    String description,
    String dateFrom,
    String dateTo,
    String status,
    int color,
    List<String> members,
  }) async {
    try {
      var response = await _client.post(
        Uri.parse(baseUrl + 'task/add'),
        body: jsonEncode({
          "name": name,
          "description": description,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "status": status,
          "color": color,
          "members": members
        }),
        headers: {"Content-Type": "application/json", "Authorization": token.value},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }

      var json = jsonDecode(response.body);

      return Result.value(json['id']);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // ===========================================================================
  @override
  Future<Result<String>> update({
    Token token,
    String id,
    String name,
    String description,
    String dateFrom,
    String dateTo,
    String status,
    int color,
    List<String> members,
  }) async {
    try {
      var response = await _client.put(
        Uri.parse(baseUrl + 'task/update'),
        body: jsonEncode({
          "id": id,
          "name": name,
          "description": description,
          "dateFrom": dateFrom,
          "dateTo": dateTo,
          "status": status,
          "color": color,
          "members": members
        }),
        headers: {"Content-Type": "application/json", "Authorization": token.value},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }

      var json = jsonDecode(response.body);

      return Result.value(json['id']);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // ===========================================================================
  @override
  Future<Result<String>> updateTaskStatus(Token token, String id, String status) async {
    try {
      var response = await _client.put(
        Uri.parse(baseUrl + 'task/update/status'),
        body: jsonEncode({"id": id, "status": status}),
        headers: {"Content-Type": "application/json", "Authorization": token.value},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }

      var json = jsonDecode(response.body);

      return Result.value(json['id']);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // ===========================================================================
  @override
  Future<Result<String>> delete(Token token, String id) async {
    try {
      var response = await _client.delete(
        Uri.parse(baseUrl + 'task/delete/$id'),
        headers: {"Authorization": token.value},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }

      var json = jsonDecode(response.body);

      return Result.value(json['id']);
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // ===========================================================================
  @override
  Future<Result<List<Task>>> getAllTasks(Token token) async {
    try {
      final response = await _client.get(
        Uri.parse(baseUrl + 'task/get/all'),
        headers: {"Authorization": token.value},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }
      var json = jsonDecode(response.body);

      final List tasks = json['tasks'];

      return Result.value(
        tasks
            .map<Task>(
              (task) => Task(
                id: task['id'],
                name: task['name'],
                description: task['description'],
                status: task['status'],
                dateFrom: task['dateFrom'],
                dateTo: task['dateTo'],
                color: task['color'],
                members: _getTaskMembers(task['members']),
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // ===========================================================================
  @override
  Future<Result<List<Task>>> getTasksByDateRange(
      Token token, String dateFrom, String dateTo) async {
    try {
      final response = await _client.get(
        Uri.parse(baseUrl + 'task/get/by/date/range/$dateFrom/$dateTo'),
        headers: {"Authorization": token.value},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }
      var json = jsonDecode(response.body);

      final List tasks = json['tasks'];
      if (tasks.isEmpty) return Result.error('No tasks found');

      return Result.value(
        tasks
            .map<Task>(
              (task) => Task(
                id: task['id'],
                name: task['name'],
                description: task['description'],
                status: task['status'],
                dateFrom: task['dateFrom'],
                dateTo: task['dateTo'],
                color: task['color'],
                members: _getTaskMembers(task['members']),
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // ===========================================================================
}
