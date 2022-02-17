//@dart=2.9

import 'package:flutter/foundation.dart';

class EmailModel {
  final String id;
  final String email;
  final String role;
  final bool hasUser;

  EmailModel({
    this.id,
    @required this.email,
    @required this.role,
    this.hasUser,
  });
}
