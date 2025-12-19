import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/day_selection_viewmodel.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'day_tab_card.dart';
import '../../../features/itinerary/views/widgets/multi_day_itinerary_list.dart';

class AppSpecialTabNDaySelectionBar extends StatelessWidget {
  const AppSpecialTabNDaySelectionBar({
    super.key,
    required this.listKey,
    required this.color,
  });

  final GlobalKey<MultiDayItineraryListState> listKey;

  /// Label for the first tab (“Notes”, “Overview”, etc.)

  /// Builder for the first tab widget

  final Color color;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DaySelectionViewModel>();

    final totalTabs = vm.totalDays;
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: totalTabs,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final dayNumber = index + 1; // Day 1, Day 2, etc.
          print("Building tab for day number: $dayNumber");

          final formattedDate = getFormattedDayLabel(
            dayNumber,
            vm.totalDays,
            vm.startDate,
          );
          final isSelected = vm.selectedDay == index;

          return Padding(
            padding: EdgeInsets.zero,
            child: IntrinsicWidth(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    vm.selectDay(index);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      listKey.currentState?.scrollToDay(dayNumber);
                    });
                  },
                  child: DayTabCard(
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
