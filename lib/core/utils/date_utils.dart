bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

List<DateTime> generateDateSequence({
  required DateTime startDate,
  required int count,
  Duration step = const Duration(days: 1),
}) {
  return List<DateTime>.generate(count, (i) => startDate.add(step * i));
}
