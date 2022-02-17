//@dart=2.9
import 'package:async/async.dart';
import 'package:auth/src/domain/email.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/domain/user.dart';

abstract class IAuthApi {
  Future<Result<String>> register(String username, String email, String password);
  Future<Result<Token>> login(String email, String password);
  Future<Result<String>> forgotPassword(String email);
  Future<Result<User>> findUser(String email);
  // ===========================================================================
  Future<Result<String>> addEmail(Token token, String email, String role);
  Future<Result<String>> updateEmail(Token token, String id, String email, String role);
  Future<Result<String>> deleteEmail(Token token, String id);
  Future<Result<List<Email>>> getAllEmails(Token token);
  // ===========================================================================
  Future<Result<String>> updateUserName(Token token, String id, String username);
  Future<Result<String>> updateUserPassword(
      Token token, String id, String oldPassword, String newPassword1, String newPassword2);
  Future<Result<String>> updateUserRole(Token token, String id, String role);
  Future<Result<String>> deleteUser(Token token, String id);
  Future<Result<List<User>>> getAllUsers(Token token);
}
