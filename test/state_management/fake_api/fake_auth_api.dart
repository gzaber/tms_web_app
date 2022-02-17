//@dart=2.9
import 'package:async/src/result/result.dart';
import 'package:auth/auth.dart';
import 'package:auth/src/domain/user.dart';
import 'package:auth/src/domain/email.dart';
import 'package:tms_web_app/models/models.dart';

class FakeAuthApi implements IAuthApi {
  List<EmailModel> emails = [];
  List<UserModel> users = [];

  FakeAuthApi() {
    emails = [
      EmailModel(id: 'id1', email: 'user1@email.com', role: 'admin', hasUser: true),
      EmailModel(id: 'id2', email: 'user2@email.com', role: 'user', hasUser: true),
    ];
    users = [
      UserModel(id: 'id1', username: 'username1', email: 'user1@email.com', role: 'admin'),
      UserModel(id: 'id2', username: 'username2', email: 'user2@email.com', role: 'user'),
    ];
  }

  void clearEmails() {
    emails = [];
  }

  void clearUsers() {
    users = [];
  }

  // ===============================================================================================
  @override
  Future<Result<String>> register(String username, String email, String password) async {
    if (username.isEmpty ||
        email.isEmpty ||
        !email.contains('@') ||
        email.contains('notallowed@email.com') ||
        password.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<Token>> login(String email, String password) async {
    if (email.isEmpty ||
        !email.contains('@') ||
        email.contains('unknown@email.com') ||
        password.isEmpty ||
        !password.contains('password'))
      return Result.error('error');
    else
      return Result.value(Token('token'));
  }

  @override
  Future<Result<String>> forgotPassword(String email) async {
    if (email.isEmpty || !email.contains('@') || email.contains('unknown@email.com'))
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<User>> findUser(String email) async {
    return Result.value(
        User(id: 'id', username: 'username', email: email, role: 'user', isConfirmed: true));
  }

  // ===============================================================================================

  @override
  Future<Result<String>> addEmail(Token token, String email, String role) async {
    if (token.value.isEmpty || email.isEmpty || !email.contains('@'))
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<String>> updateEmail(Token token, String id, String email, String role) async {
    if (token.value.isEmpty || id.isEmpty || email.isEmpty || !email.contains('@'))
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<String>> deleteEmail(Token token, String id) async {
    if (token.value.isEmpty || id.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<List<Email>>> getAllEmails(Token token) async {
    if (token.value.isEmpty || emails.isEmpty)
      return Result.error('error');
    else
      return Result.value(emails
          .map((email) =>
              Email(id: email.id, email: email.email, role: email.role, hasUser: email.hasUser))
          .toList());
  }

  // ===============================================================================================

  @override
  Future<Result<String>> updateUserName(Token token, String id, String username) async {
    if (token.value.isEmpty || id.isEmpty || username.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<String>> updateUserPassword(
      Token token, String id, String oldPassword, String newPassword1, String newPassword2) async {
    if (token.value.isEmpty ||
        id.isEmpty ||
        oldPassword.isEmpty ||
        newPassword1.isEmpty ||
        newPassword2.isEmpty ||
        (oldPassword != 'oldPassword') ||
        (newPassword1 != newPassword2))
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<String>> updateUserRole(Token token, String id, String role) async {
    if (token.value.isEmpty || id.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<String>> deleteUser(Token token, String id) async {
    if (token.value.isEmpty || id.isEmpty)
      return Result.error('error');
    else
      return Result.value('id');
  }

  @override
  Future<Result<List<User>>> getAllUsers(Token token) async {
    if (token.value.isEmpty || users.isEmpty)
      return Result.error('error');
    else
      return Result.value(users
          .map((user) => User(
              id: user.id,
              username: user.username,
              email: user.email,
              role: user.role,
              isConfirmed: user.isConfirmed))
          .toList());
  }

  // ===============================================================================================
}
