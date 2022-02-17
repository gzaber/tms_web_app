//@dart=2.9

import 'package:flutter/foundation.dart';

class Task {
  final String id;
  final String name;
  final String description;
  final String status;
  final String dateFrom;
  final String dateTo;
  final int color;
  final List<String> members;

  Task({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.status,
    @required this.dateFrom,
    @required this.dateTo,
    @required this.color,
    @required this.members,
  });
}
