//@dart=2.9

import 'package:flutter/foundation.dart';

class Email {
  final String id;
  final String email;
  final String role;
  final bool hasUser;

  const Email({
    @required this.id,
    @required this.email,
    @required this.role,
    @required this.hasUser,
  });
}
