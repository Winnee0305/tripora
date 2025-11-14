import 'package:intl/intl.dart';

String formatDateRange(DateTime start, DateTime end) {
  String startStr = "${start.day}/${start.month}/${start.year}";
  String endStr = "${end.day}/${end.month}/${end.year}";
  return "$startStr - $endStr";
}

String formatDateRangeWords(DateTime startDate, DateTime endDate) {
  return '${DateFormat('d MMM yyyy').format(startDate)} - ${DateFormat('d MMM yyyy').format(endDate)}';
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

String calculateTripDuration(DateTime startDate, DateTime endDate) {
  final totalDays =
      endDate.difference(startDate).inDays + 1; // include start day
  final totalNights = totalDays - 1;
  return '$totalDays Days, $totalNights Nights';
}

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

/// Converts a DateTime to a day number relative to the trip start date
int getDayNumber(DateTime itineraryDate, DateTime tripStartDate) {
  return itineraryDate.difference(tripStartDate).inDays + 1;
}

/// Get the actual DateTime of a given day index
DateTime getDateForDay(int dayIndex, int totalDays, DateTime startDate) {
  if (dayIndex < 1 || dayIndex > totalDays) {
    throw ArgumentError("Invalid day index: $dayIndex");
  }
  return startDate.add(Duration(days: dayIndex - 1));
}

/// Get formatted label like "Mon, 7 Oct"
String getFormattedDayLabel(int dayIndex, int totalDays, DateTime startDate) {
  final date = getDateForDay(dayIndex, totalDays, startDate);
  return DateFormat('EEE, d MMM').format(date);
}

/// Get formatted range for the trip like "6 Oct - 9 Oct"
String getTripDateRange(DateTime startDate, DateTime endDate) {
  final formatter = DateFormat('d MMM');
  return "${formatter.format(startDate)} - ${formatter.format(endDate)}";
}
