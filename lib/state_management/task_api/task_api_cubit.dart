//@dart=2.9
import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task/task.dart';
import 'package:tms_web_app/models/task_model.dart';
import 'package:tms_web_app/state_management/task_api/task_api_state.dart';

class TaskApiCubit extends Cubit<TaskApiState> {
  final ITaskApi _api;

  TaskApiCubit(this._api) : super(TaskApiInitial());

  // ===============================================================================================
  addTask(Token token, TaskModel task) async {
    emit(TaskApiLoading());
    final result = await _api.add(
        token: token,
        name: task.name,
        description: task.description,
        dateFrom: task.dateFrom,
        dateTo: task.dateTo,
        status: task.status,
        color: task.color,
        members: task.members);
    if (result.asError != null) {
      emit(TaskApiActionFailure(result.asError.error));
    } else {
      emit(TaskApiActionSuccess("Task added successfully."));
    }
  }

  // ===============================================================================================
  updateTask(Token token, TaskModel task) async {
    emit(TaskApiLoading());
    final result = await _api.update(
        token: token,
        id: task.id,
        name: task.name,
        description: task.description,
        dateFrom: task.dateFrom,
        dateTo: task.dateTo,
        status: task.status,
        color: task.color,
        members: task.members);
    if (result.asError != null) {
      emit(TaskApiActionFailure(result.asError.error));
    } else {
      emit(TaskApiActionSuccess("Task updated successfully."));
    }
  }

  // ===============================================================================================
  updateTaskStatus(Token token, String id, String status) async {
    emit(TaskApiLoading());
    final result = await _api.updateTaskStatus(token, id, status);
    if (result.asError != null) {
      emit(TaskApiActionFailure(result.asError.error));
    } else {
      emit(TaskApiActionSuccess("Task status updated successfully."));
    }
  }

  // ===============================================================================================
  deleteTask(Token token, String id) async {
    emit(TaskApiLoading());
    final result = await _api.delete(token, id);
    if (result.asError != null) {
      emit(TaskApiActionFailure(result.asError.error));
    } else {
      emit(TaskApiActionSuccess("Task deleted successfully."));
    }
  }

  // ===============================================================================================
  getAll(Token token) async {
    emit(TaskApiLoading());
    final result = await _api.getAllTasks(token);
    if (result.asError != null) {
      emit(TaskApiFailure(result.asError.error));
    } else {
      final tasks = result.asValue.value
          .map(
            (task) => TaskModel(
              id: task.id,
              name: task.name,
              description: task.description,
              status: task.status,
              dateFrom: task.dateFrom,
              dateTo: task.dateTo,
              color: task.color,
              members: task.members,
            ),
          )
          .toList();

      emit(TaskApiLoadListSuccess(tasks));
    }
  }

  // ===============================================================================================
  getByDateRange(Token token, String dateFrom, String dateTo) async {
    emit(TaskApiLoading());
    final result = await _api.getTasksByDateRange(token, dateFrom, dateTo);
    if (result.asError != null) {
      emit(TaskApiFailure(result.asError.error));
    } else {
      final tasks = result.asValue.value
          .map(
            (task) => TaskModel(
              id: task.id,
              name: task.name,
              description: task.description,
              status: task.status,
              dateFrom: task.dateFrom,
              dateTo: task.dateTo,
              color: task.color,
              members: task.members,
            ),
          )
          .toList();

      emit(TaskApiLoadListSuccess(tasks));
    }
  }
  // ===============================================================================================
}
