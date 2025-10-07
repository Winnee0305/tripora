import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_card.dart';

/// A reusable reorderable list widget for displaying itinerary items.
/// Uses ItineraryPageViewModel for data and reordering logic.
class ItineraryReorderableList extends StatelessWidget {
  const ItineraryReorderableList({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ItineraryPageViewModel>();

    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vm.itinerary.length,
      onReorder: vm.reorderItems,

      // 👇 This is the key addition
      proxyDecorator: (child, index, animation) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          elevation: 6,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: child,
          ),
        );
      },

      itemBuilder: (context, index) {
        final item = vm.itinerary[index];
        return ItineraryCard(key: ValueKey(item), item: item);
      },
    );
  }
}
