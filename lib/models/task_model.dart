//@dart=2.9
import 'package:flutter/foundation.dart';

class TaskModel {
  String id;
  String name;
  String description;
  String status;
  String dateFrom;
  String dateTo;
  int color;
  List<String> members;

  TaskModel({
    this.id,
    @required this.name,
    @required this.description,
    @required this.status,
    @required this.dateFrom,
    @required this.dateTo,
    @required this.color,
    @required this.members,
  });
}
