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

final Map<int, String> dayMap = {
  0: "Sunday",
  1: "Monday",
  2: "Tuesday",
  3: "Wednesday",
  4: "Thursday",
  5: "Friday",
  6: "Saturday",
};

// Helper to format "HHMM" → "HH:MM"
String formatTime(String time) {
  return "${time.substring(0, 2)}:${time.substring(2, 4)}";
}

// --- String capitalization extension ---
extension StringCasingExtension on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

String formatDistance(double distanceMeters) {
  if (distanceMeters < 1) return "Less than 1 m";
  if (distanceMeters < 1000) {
    return "${distanceMeters.toStringAsFixed(0)} m";
  } else {
    final km = distanceMeters / 1000;
    return "${km.toStringAsFixed(2)} km";
  }
}
