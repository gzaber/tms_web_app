//@dart=2.9

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tms_web_app/models/date_range.dart';

class DateRangeCubit extends Cubit<DateRange> {
  DateRangeCubit()
      : super(
          DateRange(
            dateFrom: DateFormat('yyyy-MM-dd').format(DateTime.now()),
            dateTo: DateFormat('yyyy-MM-dd').format(DateTime.now()),
          ),
        );

  update(String dateFrom, String dateTo) {
    emit(DateRange(dateFrom: dateFrom, dateTo: dateTo));
  }

  reset() {
    emit(
      DateRange(
        dateFrom: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        dateTo: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      ),
    );
  }
}
