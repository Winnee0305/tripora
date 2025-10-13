import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_item.dart';

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

    return ListView.builder(
      controller: widget.scrollController,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: vm.dailyItineraries.keys.length,
      itemBuilder: (context, dayIndex) {
        final day = vm.dailyItineraries.keys.elementAt(dayIndex);
        final items = vm.dailyItineraries[day]!;

        _dayKeys[day] = GlobalKey();

        return Column(
          key: _dayKeys[day],
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 16,
              ),
              child: Text(
                "Day $day • ${vm.getDateLabelForDay(day)}",
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              onReorder: (oldIndex, newIndex) =>
                  vm.reorderWithinDay(day, oldIndex, newIndex),
              itemBuilder: (context, index) {
                final item = items[index];
                return ItineraryItem(
                  key: ValueKey(item),
                  item: item,
                  isFirst: index == 0,
                  isLast: index == items.length - 1,
                  index: index,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
