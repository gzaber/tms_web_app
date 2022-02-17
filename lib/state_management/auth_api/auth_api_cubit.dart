//@dart=2.9
import 'package:auth/auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tms_web_app/models/models.dart';

import 'auth_api_state.dart';

class AuthApiCubit extends Cubit<AuthApiState> {
  final IAuthApi _api;

  AuthApiCubit(this._api) : super(AuthApiInitial());

  // ===============================================================================================
  register(String username, String email, String password) async {
    emit(AuthApiLoading());
    final result = await _api.register(username, email, password);

    if (result.asError != null) {
      emit(AuthApiFailure(result.asError.error));
    } else {
      emit(AuthApiRegisterSuccess(result.asValue.value));
    }
  }

  // ===============================================================================================
  login(String email, String password) async {
    emit(AuthApiLoading());
    final loginResult = await _api.login(email, password);

    if (loginResult.asError != null) {
      emit(AuthApiFailure(loginResult.asError.error));
    } else {
      final result = await _api.findUser(email);
      if (result.asError != null) {
        emit(AuthApiFailure(result.asError.error));
      } else {
        final _userModel = UserModel(
          id: result.asValue.value.id,
          username: result.asValue.value.username,
          email: result.asValue.value.email,
          role: result.asValue.value.role,
        );
        print('${_userModel.id}\n${_userModel.username}\n${_userModel.email}\n${_userModel.role}');

        emit(AuthApiLoginSuccess(loginResult.asValue.value, _userModel));
      }
    }
  }

  // ===============================================================================================
  forgotPassword(String email) async {
    emit(AuthApiLoading());
    final result = await _api.forgotPassword(email);

    if (result.asError != null) {
      emit(AuthApiFailure(result.asError.error));
    } else {
      emit(AuthApiForgotPasswordSuccess(result.asValue.value));
    }
  }

  // ===============================================================================================
  // ===============================================================================================
  addEmail(Token token, String email, String role) async {
    emit(AuthApiLoading());
    final result = await _api.addEmail(token, email, role);
    if (result.asError != null) {
      emit(AuthApiActionFailure(result.asError.error));
    } else {
      emit(AuthApiActionSuccess("Email added successfully."));
    }
  }

  // ===============================================================================================
  updateEmail(Token token, String id, String email, String role) async {
    emit(AuthApiLoading());
    final result = await _api.updateEmail(token, id, email, role);
    if (result.asError != null) {
      emit(AuthApiActionFailure(result.asError.error));
    } else {
      emit(AuthApiActionSuccess("Email updated successfully."));
    }
  }

  // ===============================================================================================
  deleteEmail(Token token, String id) async {
    emit(AuthApiLoading());
    final result = await _api.deleteEmail(token, id);
    if (result.asError != null) {
      emit(AuthApiActionFailure(result.asError.error));
    } else {
      emit(AuthApiActionSuccess("Email deleted successfully."));
    }
  }

  // ===============================================================================================
  getAllEmails(Token token) async {
    emit(AuthApiLoading());
    final result = await _api.getAllEmails(token);
    if (result.asError != null) {
      emit(AuthApiFailure(result.asError.error));
    } else {
      final emails = result.asValue.value
          .map(
            (email) => EmailModel(
              id: email.id,
              email: email.email,
              role: email.role,
              hasUser: email.hasUser,
            ),
          )
          .toList();

      emit(AuthApiLoadEmailListSuccess(emails));
    }
  }

  // ===============================================================================================
  // ===============================================================================================
  updateUserName(Token token, String id, String username) async {
    emit(AuthApiLoading());
    final result = await _api.updateUserName(token, id, username);
    if (result.asError != null) {
      emit(AuthApiActionFailure(result.asError.error));
    } else {
      emit(AuthApiActionSuccess("User name updated successfully."));
    }
  }

  // ===============================================================================================
  updateUserPassword(
    Token token,
    String id,
    String oldPassword,
    String newPassword1,
    String newPassword2,
  ) async {
    emit(AuthApiLoading());
    final result =
        await _api.updateUserPassword(token, id, oldPassword, newPassword1, newPassword2);
    if (result.asError != null) {
      emit(AuthApiActionFailure(result.asError.error));
    } else {
      emit(AuthApiActionSuccess("User password updated successfully."));
    }
  }

  // ===============================================================================================
  updateUserRole(Token token, String id, String role) async {
    emit(AuthApiLoading());
    final result = await _api.updateUserRole(token, id, role);
    if (result.asError != null) {
      emit(AuthApiActionFailure(result.asError.error));
    } else {
      emit(AuthApiActionSuccess("User role updated successfully."));
    }
  }

  // ===============================================================================================
  deleteUser(Token token, String id) async {
    emit(AuthApiLoading());
    final result = await _api.deleteUser(token, id);
    if (result.asError != null) {
      emit(AuthApiActionFailure(result.asError.error));
    } else {
      emit(AuthApiActionSuccess("User deleted successfully."));
    }
  }

  // ===============================================================================================
  getAllUsers(Token token) async {
    emit(AuthApiLoading());
    final result = await _api.getAllUsers(token);
    if (result.asError != null) {
      emit(AuthApiFailure(result.asError.error));
    } else {
      final users = result.asValue.value
          .map(
            (user) => UserModel(
              id: user.id,
              username: user.username,
              email: user.email,
              role: user.role,
              isConfirmed: user.isConfirmed,
            ),
          )
          .toList();

      emit(AuthApiLoadUserListSuccess(users));
    }
  }
  // ===============================================================================================

}
