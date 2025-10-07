import 'package:intl/intl.dart';

String formatDateRange(DateTime start, DateTime end) {
  String startStr = "${start.day}/${start.month}/${start.year}";
  String endStr = "${end.day}/${end.month}/${end.year}";
  return "$startStr - $endStr";
}

String getDayName(DateTime date) {
  return DateFormat('EEEE').format(date);
}
