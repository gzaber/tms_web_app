//@dart=2.9
import 'package:equatable/equatable.dart';
import 'package:tms_web_app/models/task_model.dart';

abstract class TaskApiState extends Equatable {}

// =============================================================================
class TaskApiInitial extends TaskApiState {
  @override
  List<Object> get props => [];
}

// =============================================================================
class TaskApiLoading extends TaskApiState {
  @override
  List<Object> get props => [];
}

// =============================================================================
class TaskApiLoadListSuccess extends TaskApiState {
  final List<TaskModel> tasks;

  TaskApiLoadListSuccess(this.tasks);

  @override
  List<Object> get props => [];
}

// =============================================================================

class TaskApiLoadSuccess extends TaskApiState {
  final TaskModel task;

  TaskApiLoadSuccess(this.task);

  @override
  List<Object> get props => [];
}

// =============================================================================
class TaskApiActionSuccess extends TaskApiState {
  final String message;

  TaskApiActionSuccess(this.message);

  @override
  List<Object> get props => [];
}

// =============================================================================
class TaskApiActionFailure extends TaskApiState {
  final String message;

  TaskApiActionFailure(this.message);

  @override
  List<Object> get props => [];
}

// =============================================================================
class TaskAddNew extends TaskApiState {
  @override
  List<Object> get props => [];
}

// =============================================================================
class TaskApiFailure extends TaskApiState {
  final String message;

  TaskApiFailure(this.message);

  @override
  List<Object> get props => [];
}
// =============================================================================




