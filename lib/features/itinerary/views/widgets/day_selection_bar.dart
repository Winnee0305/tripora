import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/itinerary/viewmodels/day_selection_viewmodel.dart';
import 'day__card.dart';

class DaySelectionBar extends StatelessWidget {
  const DaySelectionBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DaySelectionViewModel>();

    // Generate list of all dates in range
    final days = List.generate(
      vm.totalDays,
      (index) => vm.getDateForDay(index + 1),
    );

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,

        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final dayNumber = index + 1;
          final formattedDate = vm.getFormattedDayLabel(dayNumber);
          final isSelected = vm.selectedDay == dayNumber;

          return GestureDetector(
            onTap: () => vm.selectDay(dayNumber),

            child: DayCard(
              day: dayNumber,
              dateLabel: formattedDate, // add this field to your widget
              isSelected: isSelected,
            ),
          );
        },
      ),
    );
  }
}
