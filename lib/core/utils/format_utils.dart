import 'package:intl/intl.dart';

String formatDateRange(DateTime start, DateTime end) {
  String startStr = "${start.day}/${start.month}/${start.year}";
  String endStr = "${end.day}/${end.month}/${end.year}";
  return "$startStr - $endStr";
}

String getDayName(DateTime date) {
  return DateFormat('EEEE').format(date);
}

String getWeekdayShort(int weekday) {
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return weekdays[weekday - 1];
}

// --- String capitalization extension ---
extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
