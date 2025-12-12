import 'package:flutter/material.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/features/itinerary/views/widgets/eta_card.dart';
import 'package:tripora/features/itinerary/views/widgets/timeline_indicator.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_card.dart';

class ItineraryItem extends StatelessWidget {
  final ItineraryData itinerary;
  final bool isFirst;
  final bool isLast;
  final int index;
  final bool? showDragHandle;

  const ItineraryItem({
    super.key,
    required this.itinerary,
    this.isFirst = false,
    this.isLast = false,
    required this.index,
    this.showDragHandle,
  });

  @override
  Widget build(BuildContext context) {
    // For notes, use IntrinsicHeight so timeline extends with note height
    if (itinerary.isNote) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timeline line only (no pin) for notes
            SizedBox(
              width: 20,
              child: Column(
                children: [
                  // Top line
                  if (!isFirst)
                    Container(
                      width: 1,
                      height: 4,
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.6),
                    )
                  else
                    Container(width: 1, height: 4, color: Colors.transparent),

                  // Bottom line - expands to match note height
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 1,
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                children: [
                  ItineraryCard(
                    itinerary: itinerary,
                    showDragHandle: showDragHandle,
                  ),
                  if (!isLast) const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // For destinations, use IntrinsicHeight
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TimelineIndicator(isFirst: isFirst, isLast: isLast, index: index),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                ItineraryCard(
                  itinerary: itinerary,
                  showDragHandle: showDragHandle,
                ),
                if (!isLast) EtaCard(itinerary: itinerary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
