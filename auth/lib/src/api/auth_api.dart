//@dart=2.9
import 'dart:convert';

import 'package:async/async.dart';
import 'package:auth/src/domain/api/i_auth_api.dart';
import 'package:auth/src/domain/email.dart';
import 'package:auth/src/domain/token.dart';
import 'package:auth/src/domain/user.dart';
import 'package:http/http.dart' as http;

class AuthApi implements IAuthApi {
  final http.Client _client;
  final String baseUrl;

  AuthApi(this.baseUrl, this._client);

  // ===========================================================================
  _transformError(Map map) {
    var contents = map['error'] ?? map['errors'];
    if (contents is String) return contents;
    var errStr = contents.fold('', (prev, ele) => prev + ele.values.first + '\n');
    return errStr.trim();
  }

  // ===========================================================================
  // ===========================================================================
  @override
  Future<Result<String>> register(String username, String email, String password) async {
    try {
      var response = await _client.post(
        Uri.parse(baseUrl + 'auth/register'),
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
        headers: {"Content-Type": "application/json"},
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
  Future<Result<Token>> login(String email, String password) async {
    try {
      var response = await _client.post(
        Uri.parse(baseUrl + 'auth/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }

      var json = jsonDecode(response.body);

      return Result.value(Token(json['token']));
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // ===========================================================================
  @override
  Future<Result<String>> forgotPassword(String email) async {
    try {
      var response = await _client.post(
        Uri.parse(baseUrl + 'auth/forgot/password'),
        body: jsonEncode({'email': email}),
        headers: {"Content-Type": "application/json"},
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
  Future<Result<User>> findUser(String email) async {
    try {
      var response = await _client.get(
        Uri.parse(baseUrl + 'auth/find/user/$email'),
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }
      var json = jsonDecode(response.body);

      return Result.value(
        User(
          id: json['user']['id'],
          username: json['user']['username'],
          email: json['user']['email'],
          role: json['user']['role'],
          isConfirmed: json['user']['isConfirmed'],
        ),
      );
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  // ===========================================================================
  // ===========================================================================
  @override
  Future<Result<String>> addEmail(Token token, String email, String role) async {
    try {
      var response = await _client.post(
        Uri.parse(baseUrl + 'auth/add/email'),
        body: jsonEncode({'email': email, 'role': role}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token.value,
        },
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
  Future<Result<String>> updateEmail(Token token, String id, String email, String role) async {
    try {
      var response = await _client.put(
        Uri.parse(baseUrl + 'auth/update/email'),
        body: jsonEncode({'id': id, 'email': email, 'role': role}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token.value,
        },
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
  Future<Result<String>> deleteEmail(Token token, String id) async {
    try {
      var response = await _client.delete(
        Uri.parse(baseUrl + 'auth/delete/email/$id'),
        body: jsonEncode({'id': id}),
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
  Future<Result<List<Email>>> getAllEmails(Token token) async {
    try {
      final response = await _client.get(
        Uri.parse(baseUrl + 'auth/get/all/emails'),
        headers: {"Authorization": token.value},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }
      var json = jsonDecode(response.body);

      final List emails = json['emails'];

      return Result.value(
        emails
            .map<Email>(
              (email) => Email(
                id: email['id'],
                email: email['email'],
                role: email['role'],
                hasUser: email['hasUser'],
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Result.error(e.toString());
    }
  }
  // ===========================================================================
  // ===========================================================================

  @override
  Future<Result<String>> updateUserName(Token token, String id, String username) async {
    try {
      var response = await _client.put(
        Uri.parse(baseUrl + 'auth/update/user/name'),
        body: jsonEncode({'id': id, 'username': username}),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token.value,
        },
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
  Future<Result<String>> updateUserPassword(
    Token token,
    String id,
    String oldPassword,
    String newPassword1,
    String newPassword2,
  ) async {
    try {
      var response = await _client.put(
        Uri.parse(baseUrl + 'auth/update/user/password'),
        body: jsonEncode({
          'id': id,
          'oldPassword': oldPassword,
          'newPassword1': newPassword1,
          'newPassword2': newPassword2,
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
  Future<Result<String>> updateUserRole(Token token, String id, String role) async {
    try {
      var response = await _client.put(
        Uri.parse(baseUrl + 'auth/update/user/role'),
        body: jsonEncode({'id': id, 'role': role}),
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
  Future<Result<String>> deleteUser(Token token, String id) async {
    try {
      var response = await _client.delete(
        Uri.parse(baseUrl + 'auth/delete/user/$id'),
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
  Future<Result<List<User>>> getAllUsers(Token token) async {
    try {
      final response = await _client.get(
        Uri.parse(baseUrl + 'auth/get/all/users'),
        headers: {"Authorization": token.value},
      );

      if (response.statusCode != 200) {
        Map map = jsonDecode(response.body);
        return Result.error(_transformError(map));
      }
      var json = jsonDecode(response.body);

      final List users = json['users'];

      return Result.value(
        users
            .map<User>(
              (user) => User(
                id: user['id'],
                username: user['username'],
                email: user['email'],
                role: user['role'],
                isConfirmed: user['isConfirmed'],
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
