//@dart=2.9

import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String role;
  final bool isConfirmed;

  User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.role,
    @required this.isConfirmed,
  });
}
