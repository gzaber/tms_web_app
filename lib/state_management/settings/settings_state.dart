//@dart=2.9
import 'package:equatable/equatable.dart';
import 'package:tms_web_app/models/models.dart';

abstract class SettingsState extends Equatable {}

// =============================================================================
class SettingsInitial extends SettingsState {
  @override
  List<Object> get props => [];
}

// =============================================================================
class SettingsLoadInProgress extends SettingsState {
  @override
  List<Object> get props => [];
}

// =============================================================================
class SettingsTaskLoadSuccess extends SettingsState {
  final TaskModel task;

  SettingsTaskLoadSuccess(this.task);

  @override
  List<Object> get props => [task];
}

// =============================================================================
class SettingsHideForm extends SettingsState {
  @override
  List<Object> get props => [];
}

// =============================================================================
// =============================================================================
class SettingsUserLoadSuccess extends SettingsState {
  final UserModel user;

  SettingsUserLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

// =============================================================================
class SettingsEmailLoadSuccess extends SettingsState {
  final EmailModel email;

  SettingsEmailLoadSuccess(this.email);

  @override
  List<Object> get props => [email];
}

// =============================================================================
// =============================================================================

