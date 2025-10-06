import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripora/features/poi/models/operating_hours.dart';

class PoiOperatingHoursViewModel extends ChangeNotifier {
  final List<OperatingHours> hours;

  PoiOperatingHoursViewModel(this.hours);

  bool get isOpenNow {
    final now = DateTime.now();
    final weekday = DateFormat('EEEE').format(now);

    final today = hours.firstWhere(
      (h) => h.day.toLowerCase() == weekday.toLowerCase(),
      orElse: () =>
          OperatingHours(day: weekday, open: "Closed", close: "Closed"),
    );

    if (today.open.toLowerCase() == "closed") return false;

    final openTime = _parseTime(today.open, now);
    final closeTime = _parseTime(today.close, now);

    return now.isAfter(openTime) && now.isBefore(closeTime);
  }

  String get statusText => isOpenNow ? "Open" : "Closed";

  Color statusColor(BuildContext context) =>
      isOpenNow ? Colors.green : Colors.red;

  String get fullSchedule {
    return hours
        .map((h) {
          if (h.open.toLowerCase() == "closed") {
            return "${h.day}: Closed";
          }
          return "${h.day}: ${h.open} - ${h.close}";
        })
        .join("\n");
  }

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

  String get openOrCloseHours {
    if (isOpenNow) {
      return "Closes at ${hours.firstWhere((h) => h.day.toLowerCase() == DateFormat('EEEE').format(DateTime.now()).toLowerCase()).close}";
    } else {
      return "Opens at ${hours.firstWhere((h) => h.day.toLowerCase() == DateFormat('EEEE').format(DateTime.now()).toLowerCase()).open}";
    }
  }
}
