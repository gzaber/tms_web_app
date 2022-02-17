//@dart=2.9
import 'package:auth/auth.dart';
import 'package:flutter/foundation.dart';

class AuthData {
  final String id;
  final String username;
  final String email;
  final String role;
  final Token token;

  AuthData({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.role,
    @required this.token,
  });
}
