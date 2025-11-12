import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripora/features/poi/models/operating_hours.dart';

class PoiOperatingHoursViewModel extends ChangeNotifier {
  final List<OperatingHours> hours;

  PoiOperatingHoursViewModel(this.hours);

  // Computed property instead of field
  bool get is24Open =>
      hours.length == 1 &&
      hours[0].day.toLowerCase() == "sunday" &&
      (hours[0].open == "00:00" || hours[0].open == "0000") &&
      (hours[0].close.toLowerCase() == "open 24 hours" ||
          hours[0].close.isEmpty);

  bool get isOpenNow {
    final now = DateTime.now();
    final weekday = DateFormat('EEEE').format(now);

    // Special 24h Sunday case
    if (is24Open) return true;

    final today = hours.firstWhere(
      (h) => h.day.toLowerCase() == weekday.toLowerCase(),
      orElse: () =>
          OperatingHours(day: weekday, open: "Closed", close: "Closed"),
    );

    if (_isOpen24(today)) return true;
    if (today.open.toLowerCase() == "closed") return false;

    final openTime = _parseTime(today.open, now);
    final closeTime = _parseTime(today.close, now);

    return now.isAfter(openTime) && now.isBefore(closeTime);
  }

  String get statusText => isOpenNow ? "Open 24 hours" : "Closed";

  Color statusColor(BuildContext context) =>
      isOpenNow ? Colors.green : Colors.red;

  DateTime _parseTime(String time, DateTime base) {
    final parts = time.split(":");
    return DateTime(
      base.year,
      base.month,
      base.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  bool _isOpen24(OperatingHours h) {
    return (h.open == "0000" || h.open == "00:00") &&
        (h.close.isEmpty || h.close.toLowerCase() == "closed");
  }

  String get openOrCloseHours {
    if (is24Open) return "Open 24 hours";

    final weekday = DateFormat('EEEE').format(DateTime.now());
    final todayHours = hours.firstWhere(
      (h) => h.day.toLowerCase() == weekday.toLowerCase(),
      orElse: () => OperatingHours(day: weekday, open: "N/A", close: "N/A"),
    );

    if (_isOpen24(todayHours)) return "Open 24 hours";
    if (todayHours.open.toLowerCase() == "closed") return "Closed today";

    return isOpenNow
        ? "Closes at ${todayHours.close}"
        : "Opens at ${todayHours.open}";
  }
}
