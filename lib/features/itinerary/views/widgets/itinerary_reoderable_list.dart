import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_card.dart';

class ItineraryReorderableList extends StatefulWidget {
  const ItineraryReorderableList({super.key});

  @override
  State<ItineraryReorderableList> createState() =>
      _ItineraryReorderableListState();
}

class _ItineraryReorderableListState extends State<ItineraryReorderableList> {
  @override
  void initState() {
    super.initState();
    // Load route info initially
    Future.microtask(
      () => context.read<ItineraryPageViewModel>().loadRouteInfo(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ItineraryPageViewModel>();

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.itinerary.length,
      onReorder: vm.reorderItems,
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: child,
          ),
        );
      },
      itemBuilder: (context, index) {
        final item = vm.itinerary[index];
        item.routeInfo = vm.routeInfoMap[index];

        return ItineraryCard(
          key: ValueKey(item),
          item: item,
          isFirst: index == 0,
          isLast: index == vm.itinerary.length - 1,
          index: index,
        );
      },
    );
  }
}
