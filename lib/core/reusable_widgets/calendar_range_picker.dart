import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/theme/app_text_style.dart';

/// A reusable range calendar widget.
/// Supports any start/end date logic via callback parameters.
class CalendarRangePicker extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTime> onFocusedDayChanged;
  final void Function(DateTime?, DateTime?) onDateRangeChanged;

  final DateTime firstDay;
  final DateTime lastDay;

  CalendarRangePicker({
    super.key,
    required this.focusedDay,
    required this.startDate,
    required this.endDate,
    required this.onDateRangeChanged,
    required this.onFocusedDayChanged,
    DateTime? firstDay,
    DateTime? lastDay,
  }) : firstDay = firstDay ?? DateTime(2024, 1, 1),
       lastDay = lastDay ?? DateTime(2030, 12, 31);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlightColor = theme.colorScheme.primary.withOpacity(0.2);
    final primaryColor = theme.colorScheme.primary;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: AppWidgetStyles.cardDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(20)),

      child: TableCalendar(
        rowHeight: 40,
        calendarFormat: CalendarFormat.month,
        firstDay: firstDay,
        lastDay: lastDay,
        focusedDay: focusedDay,
        rangeStartDay: startDate,
        rangeEndDay: endDate,
        rangeSelectionMode: RangeSelectionMode.toggledOn,
        selectedDayPredicate: (day) =>
            isSameDay(day, startDate) || isSameDay(day, endDate),
        onRangeSelected: (start, end, focused) {
          onDateRangeChanged(start, end);
          onFocusedDayChanged(focused);
        },
        onPageChanged: onFocusedDayChanged,
        headerStyle: HeaderStyle(
          headerPadding: const EdgeInsets.symmetric(vertical: 4),
          headerMargin: const EdgeInsets.only(),
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: (theme.textTheme.titleMedium ?? const TextStyle())
              .copyWith(
                fontWeight: ManropeFontWeight.semiBold,
                color: theme.colorScheme.secondary,
              ),
          leftChevronIcon: Icon(
            CupertinoIcons.chevron_left,
            color: theme.colorScheme.secondary,
          ),
          rightChevronIcon: Icon(
            CupertinoIcons.chevron_right,
            color: theme.colorScheme.secondary,
          ),
        ),
        calendarStyle: CalendarStyle(
          rangeHighlightColor: highlightColor,
          rangeStartDecoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          rangeEndDecoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: primaryColor.withOpacity(0),
            shape: BoxShape.circle,
          ),

          selectedDecoration: BoxDecoration(
            color: primaryColor,
            shape: BoxShape.circle,
          ),
          todayTextStyle: (theme.textTheme.bodyMedium ?? const TextStyle())
              .copyWith(
                fontWeight: ManropeFontWeight.semiBold,
                color: theme.colorScheme.primary,
              ),
          weekendTextStyle: (theme.textTheme.bodyMedium ?? const TextStyle())
              .copyWith(
                fontWeight: ManropeFontWeight.semiBold,
                color: theme.colorScheme.onSurface,
              ),
          defaultTextStyle: (theme.textTheme.bodyMedium ?? const TextStyle())
              .copyWith(
                fontWeight: ManropeFontWeight.semiBold,
                color: theme.colorScheme.onSurface,
              ),
          selectedTextStyle: (theme.textTheme.titleLarge ?? const TextStyle())
              .copyWith(
                fontWeight: ManropeFontWeight.semiBold,
                color: theme.colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }
}
