//@dart=2.9
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tms_web_app/helpers/ui_helper.dart';
import 'package:tms_web_app/models/models.dart';
import 'package:tms_web_app/state_management/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  final TaskModel defaultTaskModel = TaskModel(
    name: '',
    description: '',
    status: 'todo',
    dateFrom: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    dateTo: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    color: UIHelper.themeColor.value,
    members: [],
  );

  final EmailModel defaultEmailModel = EmailModel(
    email: '',
    role: 'user',
    hasUser: false,
  );

  // ===========================================================================
  showTaskForm(TaskModel taskModel) {
    emit(SettingsLoadInProgress());
    emit(SettingsTaskLoadSuccess(taskModel));
  }

  // ===========================================================================
  showAddTaskForm() {
    emit(SettingsLoadInProgress());
    emit(SettingsTaskLoadSuccess(defaultTaskModel));
  }

  // ===========================================================================
  hideForm() {
    emit(SettingsHideForm());
  }

  // ===========================================================================
  showUserForm(UserModel userModel) {
    emit(SettingsLoadInProgress());
    emit(SettingsUserLoadSuccess(userModel));
  }

  // ===========================================================================
  showEmailForm(EmailModel emailModel) {
    emit(SettingsLoadInProgress());
    emit(SettingsEmailLoadSuccess(emailModel));
  }

  // ===========================================================================
  showAddEmailForm() {
    emit(SettingsLoadInProgress());
    emit(SettingsEmailLoadSuccess(defaultEmailModel));
  }

  // ===========================================================================

}
