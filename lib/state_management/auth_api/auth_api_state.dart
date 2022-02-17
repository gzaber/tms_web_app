//@dart=2.9
import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:tms_web_app/models/models.dart';

abstract class AuthApiState extends Equatable {}

// =============================================================================
class AuthApiInitial extends AuthApiState {
  @override
  List<Object> get props => [];
}

// =============================================================================
class AuthApiLoading extends AuthApiState {
  @override
  List<Object> get props => [];
}

// =============================================================================
class AuthApiLoginSuccess extends AuthApiState {
  final Token token;
  final UserModel userModel;

  AuthApiLoginSuccess(this.token, this.userModel);

  @override
  List<Object> get props => [token, userModel];
}

// =============================================================================
class AuthApiRegisterSuccess extends AuthApiState {
  final String id;

  AuthApiRegisterSuccess(this.id);
  @override
  List<Object> get props => [id];
}

// =============================================================================
class AuthApiForgotPasswordSuccess extends AuthApiState {
  final String id;

  AuthApiForgotPasswordSuccess(this.id);
  @override
  List<Object> get props => [id];
}

// =============================================================================
class AuthApiFailure extends AuthApiState {
  final String message;

  AuthApiFailure(this.message);

  @override
  List<Object> get props => [message];
}

// =============================================================================
// =============================================================================
class AuthApiLoadUserListSuccess extends AuthApiState {
  final List<UserModel> users;

  AuthApiLoadUserListSuccess(this.users);
  @override
  List<Object> get props => [users];
}

// =============================================================================
class AuthApiLoadEmailListSuccess extends AuthApiState {
  final List<EmailModel> emails;

  AuthApiLoadEmailListSuccess(this.emails);
  @override
  List<Object> get props => [emails];
}

// =============================================================================
// =============================================================================
class AuthApiActionSuccess extends AuthApiState {
  final String message;

  AuthApiActionSuccess(this.message);

  @override
  List<Object> get props => [];
}

// =============================================================================
class AuthApiActionFailure extends AuthApiState {
  final String message;

  AuthApiActionFailure(this.message);

  @override
  List<Object> get props => [];
}
// =============================================================================
