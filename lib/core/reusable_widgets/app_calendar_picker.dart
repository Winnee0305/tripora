import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

/// A reusable calendar picker widget that matches the app theme
/// Used for selecting dates with a beautiful, themed UI
class AppCalendarPicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateSelected;
  final String title;

  const AppCalendarPicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
    this.title = "Select Date",
  });

  @override
  State<AppCalendarPicker> createState() => _AppCalendarPickerState();
}

class _AppCalendarPickerState extends State<AppCalendarPicker> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _displayedMonth = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
    );
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + 1,
      );
    });
  }

  void _showMonthYearPicker() {
    showDialog(
      context: context,
      builder: (context) => _MonthYearPickerDialog(
        initialDate: _displayedMonth,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        onDateSelected: (date) {
          setState(() {
            _displayedMonth = date;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  bool _isDateInRange(DateTime date) {
    return !date.isBefore(widget.firstDate) && !date.isAfter(widget.lastDate);
  }

  bool _isSameMonth(DateTime date) {
    return date.year == _displayedMonth.year &&
        date.month == _displayedMonth.month;
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInPreviousMonth = firstDay.weekday - 1; // 0 = Monday, 6 = Sunday

    final days = <DateTime>[];

    // Add days from previous month
    for (int i = daysInPreviousMonth; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }

    // Add days of current month
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i));
    }

    // Add days from next month to fill the grid
    final remainingDays = (42 - days.length); // 6 weeks * 7 days
    for (int i = 1; i <= remainingDays; i++) {
      days.add(lastDay.add(Duration(days: i)));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = _getDaysInMonth(_displayedMonth);
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: AppWidgetStyles.cardDecoration(context).copyWith(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // --- Handle bar ---
          Center(
            child: Container(
              width: 40,
              height: 5,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // --- Title ---
          Text(
            widget.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // --- Month/Year navigation ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: const Icon(Icons.chevron_left),
                color: theme.colorScheme.primary,
              ),
              GestureDetector(
                onTap: _showMonthYearPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_monthName(_displayedMonth.month)} ${_displayedMonth.year}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: ManropeFontWeight.semiBold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: _nextMonth,
                icon: const Icon(Icons.chevron_right),
                color: theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // --- Week day headers ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weekDays.map((day) {
              return SizedBox(
                width: 40,
                child: Center(
                  child: Text(
                    day,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: ManropeFontWeight.semiBold,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // --- Calendar grid ---
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final date = days[index];
              final isCurrentMonth = _isSameMonth(date);
              final isSelected = _isSameDay(date, _selectedDate);
              final isInRange = _isDateInRange(date);
              final isToday = _isSameDay(date, DateTime.now());

              return GestureDetector(
                onTap: isCurrentMonth && isInRange
                    ? () {
                        setState(() {
                          _selectedDate = date;
                        });
                        widget.onDateSelected(date);
                        Navigator.pop(context);
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : isToday
                        ? theme.colorScheme.primary.withOpacity(0.1)
                        : Colors.transparent,
                    border: isToday && !isSelected
                        ? Border.all(
                            color: theme.colorScheme.primary,
                            width: 1.5,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isSelected || isToday
                            ? ManropeFontWeight.semiBold
                            : ManropeFontWeight.regular,
                        color: isSelected
                            ? Colors.white
                            : isCurrentMonth
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // --- Confirm button ---
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                widget.onDateSelected(_selectedDate);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Confirm',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: ManropeFontWeight.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}

/// Dialog for selecting month and year
class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime> onDateSelected;

  const _MonthYearPickerDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;
  late ScrollController _yearScrollController;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
    _yearScrollController = ScrollController();

    // Initialize scroll controller to position at the selected year
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final yearList = List<int>.generate(
        widget.lastDate.year - widget.firstDate.year + 1,
        (index) => widget.firstDate.year + index,
      );

      final index = yearList.indexOf(_selectedYear);
      if (index != -1 && _yearScrollController.hasClients) {
        // Each item height including all spacing
        final itemHeight = 56.0;
        final offset = index * itemHeight;
        _yearScrollController.jumpTo(
          offset.clamp(0.0, _yearScrollController.position.maxScrollExtent),
        );
      }
    });
  }

  @override
  void dispose() {
    _yearScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    // Generate year list
    final yearList = List<int>.generate(
      widget.lastDate.year - widget.firstDate.year + 1,
      (index) => widget.firstDate.year + index,
    );

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(24),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Month & Year',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // --- Year Picker ---
            Text(
              'Year',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: ManropeFontWeight.semiBold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 150,
              child: SingleChildScrollView(
                controller: _yearScrollController,
                child: Column(
                  children: yearList.map((year) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedYear = year;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: _selectedYear == year
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          year.toString(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: _selectedYear == year
                                ? ManropeFontWeight.bold
                                : ManropeFontWeight.regular,
                            color: _selectedYear == year
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- Month Picker ---
            Text(
              'Month',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: ManropeFontWeight.semiBold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(12, (index) {
                final month = index + 1;
                final isSelected = _selectedMonth == month;

                return SizedBox(
                  width: (MediaQuery.of(context).size.width - 96) / 4,
                  height: 50,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMonth = month;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          months[index],
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? ManropeFontWeight.bold
                                : ManropeFontWeight.regular,
                            color: isSelected
                                ? Colors.white
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // --- Action Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.onDateSelected(
                      DateTime(_selectedYear, _selectedMonth),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: Text(
                    'Confirm',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: ManropeFontWeight.semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
