//@dart=2.9
import 'package:async/async.dart';
import 'package:auth/auth.dart';
import 'package:task/src/domain/task.dart';

abstract class ITaskApi {
  Future<Result<String>> add({
    Token token,
    String name,
    String description,
    String dateFrom,
    String dateTo,
    String status,
    int color,
    List<String> members,
  });
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
  });
  Future<Result<String>> updateTaskStatus(
      Token token, String id, String status);
  Future<Result<String>> delete(Token token, String id);
  Future<Result<List<Task>>> getAllTasks(Token token);
  Future<Result<List<Task>>> getTasksByDateRange(
      Token token, String dateFrom, String dateTo);
}
