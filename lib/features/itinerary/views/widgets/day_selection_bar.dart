import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/features/itinerary/viewmodels/day_selection_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/notes_tab_card.dart';
import 'day__card.dart';
import 'multi_day_itinerary_list.dart';

class DaySelectionBar extends StatelessWidget {
  const DaySelectionBar({super.key, required this.listKey});

  final GlobalKey<MultiDayItineraryListState> listKey;

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
          // index 0 = Notes tab, index 1..N = Day 1..N
          final isNotesTab = index == 0;
          final dayNumber = isNotesTab
              ? 1
              : index; // map properly for day logic
          final formattedDate = isNotesTab
              ? ""
              : vm.getFormattedDayLabel(dayNumber);
          final isSelected = vm.selectedDay == index;

          return Padding(
            padding: isNotesTab
                ? const EdgeInsets.only(right: 10)
                : EdgeInsets.zero,
            child: IntrinsicWidth(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: isNotesTab
                      ? BorderRadius.circular(50)
                      : BorderRadius.circular(12),
                  onTap: () {
                    vm.selectDay(index);
                    if (!isNotesTab) {
                      // Wait until ItineraryContent finishes building
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        listKey.currentState?.scrollToDay(dayNumber);
                      });
                    }
                  },
                  child: isNotesTab
                      ? NotesTabCard(isSelected: isSelected)
                      : DayCard(
                          day: dayNumber,
                          dateLabel: formattedDate,
                          isSelected: isSelected,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
