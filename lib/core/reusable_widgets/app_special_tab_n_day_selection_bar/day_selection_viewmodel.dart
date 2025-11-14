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
    if (day == 0) {
      _selectedDay = 0;
      notifyListeners();
    } else if (day >= 1 && day <= totalDays) {
      _selectedDay = day;
      notifyListeners();
    }
  }
}
