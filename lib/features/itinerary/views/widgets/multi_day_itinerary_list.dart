import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/itinerary/views/widgets/add_edit_itinerary_bottom_sheet.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/itinerary/viewmodels/weather_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_item.dart';
import 'package:tripora/features/itinerary/views/widgets/lodging_card.dart';
import 'package:tripora/features/itinerary/views/widgets/weather_card.dart';

@immutable
class _DraggedItinerary {
  const _DraggedItinerary({required this.itinerary, required this.fromDay});
  final ItineraryData itinerary;
  final int fromDay;
}

class MultiDayItineraryList extends StatefulWidget {
  const MultiDayItineraryList({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<MultiDayItineraryList> createState() => MultiDayItineraryListState();
}

class MultiDayItineraryListState extends State<MultiDayItineraryList> {
  final Map<int, GlobalKey> _dayKeys = {}; // For scroll linking

  void scrollToDay(int day) {
    final keyContext = _dayKeys[day]?.currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ItineraryViewModel>();
    final weatherVm = context.watch<WeatherViewModel>();

    return Column(
      children: List.generate(vm.itinerariesMap.keys.length, (dayIndex) {
        final day = vm.itinerariesMap.keys.elementAt(dayIndex);
        final items = vm.itinerariesMap[day]!;

        _dayKeys[day] = GlobalKey();

        return DragTarget<_DraggedItinerary>(
          key: _dayKeys[day],
          builder: (context, candidateData, rejectedData) {
            final dayWeatherForecast = (weatherVm.dailyForecasts.length >= day)
                ? weatherVm.dailyForecasts[day - 1]
                : null;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    "Day $day • ${getFormattedDayLabel(day, vm.itinerariesMap.keys.length, vm.trip!.startDate!)}",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: ManropeFontWeight.semiBold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // ----- Weather card
                if (dayWeatherForecast == null)
                  WeatherCard(condition: "", temperature: 0.0, lastUpdated: "")
                else if (dayWeatherForecast.condition != "Unknown" &&
                    dayWeatherForecast.temperature != 0.0)
                  WeatherCard(
                    condition: dayWeatherForecast.condition,
                    temperature: dayWeatherForecast.temperature,
                    lastUpdated: "Updated just now",
                  )
                else
                  const SizedBox(height: 0),
                const SizedBox(height: 16),

                const SizedBox(height: 26),
                // ----- Itinerary items -----
                ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  onReorder:
                      (
                        oldIndex,
                        newIndex,
                      ) => // to implement reordering when within same day
                      context.read<ItineraryViewModel>().reorderWithinDay(
                        day,
                        oldIndex,
                        newIndex,
                      ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    // Each item is both draggable and a drop target
                    return DragTarget<_DraggedItinerary>(
                      key: ValueKey(item),
                      builder: (context, candidateData, rejectedData) {
                        final isActive = candidateData.isNotEmpty;
                        // Highlight drop target when active
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Highlight drop target when active
                            if (isActive)
                              Container(
                                height: 12,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.12),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                              ),
                            // The actual itinerary item with drag handle
                            Stack(
                              children: [
                                // The itinerary item card
                                GestureDetector(
                                  child: ItineraryItem(
                                    itinerary: item,
                                    isFirst: index == 0,
                                    isLast: index == items.length - 1,
                                    index: index,
                                  ),
                                  onTap: () {
                                    _openEditItinerarySheet(context, item);
                                  },
                                ),
                                // The drag handle
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  // Using LongPressDraggable for better UX
                                  child: LongPressDraggable<_DraggedItinerary>(
                                    data: _DraggedItinerary(
                                      itinerary: item,
                                      fromDay: day,
                                    ),
                                    feedback: Material(
                                      elevation: 6,
                                      borderRadius: BorderRadius.circular(8),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 360,
                                        ),
                                        child: Opacity(
                                          opacity: 0.95,
                                          child: ItineraryItem(
                                            itinerary: item,
                                            isFirst: true,
                                            isLast: true,
                                            index: index,
                                          ),
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: Opacity(
                                      opacity: 0.3,
                                      child: Icon(
                                        Icons.open_with,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        size: 12,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.open_with,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      onWillAcceptWithDetails: (details) {
                        return details.data.fromDay != day;
                      },
                      onAcceptWithDetails: (details) {
                        if (!mounted) return; // <-- add this line
                        final dragged = details.data;
                        vm.moveItemBetweenDays(
                          dragged.fromDay,
                          day,
                          dragged.itinerary,
                          index,
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                AppButton.textOnly(
                  text: 'Add Activity',
                  radius: 10,
                  minWidth: double.infinity,
                  minHeight: 36,
                  backgroundVariant: BackgroundVariant.primaryTrans,
                  onPressed: () {
                    final draftItinerary = ItineraryData.empty(
                      vm.getDate(day),
                      vm.getLastSequence(day),
                    );

                    _openEditItinerarySheet(context, draftItinerary);
                  },
                ),
                const SizedBox(height: 24),
                // Trailing drop target to append at end of day
                DragTarget<_DraggedItinerary>(
                  builder: (context, candidateData, rejectedData) {
                    final isActive = candidateData.isNotEmpty;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      height: isActive ? 16 : 8,
                      margin: const EdgeInsets.only(top: 8, bottom: 4),
                      decoration: isActive
                          ? BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.12),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                            )
                          : null,
                    );
                  },
                  onWillAcceptWithDetails: (details) {
                    return details.data.fromDay != day;
                  },
                  onAcceptWithDetails: (details) {
                    final dragged = details.data;
                    final insertIndex = vm.itinerariesMap[day]?.length ?? 0;
                    vm.moveItemBetweenDays(
                      dragged.fromDay,
                      day,
                      dragged.itinerary,
                      insertIndex,
                    );
                  },
                ),
              ],
            );
          },
          onWillAcceptWithDetails: (details) {
            // Accept drops from other days only to avoid redundant moves
            return details.data.fromDay != day;
          },
          onAcceptWithDetails: (details) {
            final dragged = details.data;
            // Append to end of the target day for simplicity. Users can reorder within day afterwards.
            final insertIndex = vm.itinerariesMap[day]?.length ?? 0;
            vm.moveItemBetweenDays(
              dragged.fromDay,
              day,
              dragged.itinerary,
              insertIndex,
            );
          },
        );
      }),
    );
  }

  void _openEditItinerarySheet(
    BuildContext context, [
    ItineraryData? itinerary,
  ]) {
    final vm = context.read<ItineraryViewModel>();

    // Reset and populate if editing
    vm.clearForm();
    if (itinerary != null) {
      vm.populateFromItinerary(itinerary);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeNotifierProvider.value(
        value: vm,
        child: AddEditItineraryBottomSheet(itinerary: itinerary),
      ),
    );
  }
}
