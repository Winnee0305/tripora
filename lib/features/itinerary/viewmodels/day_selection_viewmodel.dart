import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// ViewModel that manages day selection in itinerary or trip planning screens.
class DaySelectionViewModel extends ChangeNotifier {
  /// Trip start and end dates
  final DateTime startDate;
  final DateTime endDate;

  /// Currently selected day index (1-based)
  int _selectedDay = 1;
  int get selectedDay => _selectedDay;

  DaySelectionViewModel({required this.startDate, required this.endDate});

  /// Total number of days in the trip (inclusive)
  int get totalDays => endDate.difference(startDate).inDays + 1;

  /// Select a specific day
  void selectDay(int day) {
    if (day >= 1 && day <= totalDays) {
      _selectedDay = day;
      notifyListeners();
    }
  }

  /// Get the actual DateTime of a given day index
  DateTime getDateForDay(int dayIndex) {
    if (dayIndex < 1 || dayIndex > totalDays) {
      throw ArgumentError("Invalid day index: $dayIndex");
    }
    return startDate.add(Duration(days: dayIndex - 1));
  }

  /// Get formatted label like "Mon, 7 Oct"
  String getFormattedDayLabel(int dayIndex) {
    final date = getDateForDay(dayIndex);
    return DateFormat('EEE, d MMM').format(date);
  }

  /// Get formatted range for the trip like "6 Oct - 9 Oct"
  String get tripDateRange {
    final formatter = DateFormat('d MMM');
    return "${formatter.format(startDate)} - ${formatter.format(endDate)}";
  }
}
