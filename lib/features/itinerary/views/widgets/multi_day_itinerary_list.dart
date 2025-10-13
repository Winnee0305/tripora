import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_item.dart';

@immutable
class _DraggedItinerary {
  const _DraggedItinerary({required this.item, required this.fromDay});
  final Itinerary item;
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

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<ItineraryPageViewModel>().loadAllDayRoutes(),
    );
  }

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
    final vm = context.watch<ItineraryPageViewModel>();

    return Column(
      children: List.generate(vm.dailyItineraries.keys.length, (dayIndex) {
        final day = vm.dailyItineraries.keys.elementAt(dayIndex);
        final items = vm.dailyItineraries[day]!;

        _dayKeys[day] = GlobalKey();

        return DragTarget<_DraggedItinerary>(
          key: _dayKeys[day],
          builder: (context, candidateData, rejectedData) {
            final isActive = candidateData.isNotEmpty;
            return Container(
              decoration: isActive
                  ? BoxDecoration(
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.5),
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 16,
                    ),
                    child: Text(
                      "Day $day • ${vm.getDateLabelForDay(day)}",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Per-day white cards: Weather & Lodging (hardcoded for now)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.wb_sunny_outlined, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  vm.getWeatherForDay(day) ??
                                      (day == 1 ? "Sunny 29°C" : "Cloudy 27°C"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.hotel, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  vm.getLodgingForDay(day) ??
                                      (day == 1
                                          ? "AMES Hotel"
                                          : "Motel Riverside"),
                                ),
                              ),
                              const Text(
                                "CHECK IN",
                                style: TextStyle(color: Colors.purple),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: items.length,
                    onReorder: (oldIndex, newIndex) =>
                        vm.reorderWithinDay(day, oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return LongPressDraggable<_DraggedItinerary>(
                        key: ValueKey(item),
                        data: _DraggedItinerary(item: item, fromDay: day),
                        feedback: Material(
                          elevation: 6,
                          borderRadius: BorderRadius.circular(8),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: Opacity(
                              opacity: 0.95,
                              child: ItineraryItem(
                                item: item,
                                isFirst: true,
                                isLast: true,
                                index: index,
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: ItineraryItem(
                            key: ValueKey(item),
                            item: item,
                            isFirst: index == 0,
                            isLast: index == items.length - 1,
                            index: index,
                          ),
                        ),
                        child: ItineraryItem(
                          key: ValueKey(item),
                          item: item,
                          isFirst: index == 0,
                          isLast: index == items.length - 1,
                          index: index,
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
          onWillAcceptWithDetails: (details) {
            // Accept drops from other days only to avoid redundant moves
            return details.data.fromDay != day;
          },
          onAcceptWithDetails: (details) {
            final dragged = details.data;
            // Append to end of the target day for simplicity. Users can reorder within day afterwards.
            final insertIndex = vm.dailyItineraries[day]?.length ?? 0;
            vm.moveItemBetweenDays(
              dragged.fromDay,
              day,
              dragged.item,
              insertIndex,
            );
          },
        );
      }),
    );
  }
}
