import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/day_selection_viewmodel.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/special_tab_card.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'day_tab_card.dart';
import '../../../features/itinerary/views/widgets/multi_day_itinerary_list.dart';

class AppSpecialTabNDaySelectionBar extends StatelessWidget {
  const AppSpecialTabNDaySelectionBar({
    super.key,
    required this.listKey,
    required this.firstTabLabel,
    required this.color,
  });

  final GlobalKey<MultiDayItineraryListState> listKey;

  /// Label for the first tab (“Notes”, “Overview”, etc.)
  final String firstTabLabel;

  /// Builder for the first tab widget

  final Color color;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DaySelectionViewModel>();

    // Generate list of all dates in range (+1 for the first tab)
    final totalTabs = vm.totalDays + 1; // +1 for Notes or Overview tab

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: totalTabs,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSpecialTab = index == 0; // NotesTab or OverviewTab
          final dayNumber = index; // Day 1, Day 2, etc.

          final formattedDate = isSpecialTab
              ? ""
              : getFormattedDayLabel(dayNumber, vm.totalDays, vm.startDate);
          final isSelected = vm.selectedDay == index;

          return Padding(
            padding: isSpecialTab
                ? const EdgeInsets.only(right: 10)
                : EdgeInsets.zero,
            child: IntrinsicWidth(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(isSpecialTab ? 50 : 12),
                  onTap: () {
                    vm.selectDay(index);
                    if (!isSpecialTab) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        listKey.currentState?.scrollToDay(dayNumber);
                      });
                    }
                  },
                  child: isSpecialTab
                      ? SpecialTabCard(
                          text: firstTabLabel,
                          isSelected: isSelected,
                          color: color,
                        )
                      : DayTabCard(
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
