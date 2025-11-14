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

  const ItineraryItem({
    super.key,
    required this.itinerary,
    this.isFirst = false,
    this.isLast = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ----- Timeline indicator
          TimelineIndicator(isFirst: isFirst, isLast: isLast, index: index),

          const SizedBox(width: 12), // Space between timeline and card
          // ----- Card content
          Expanded(
            // Take the remaining horizontal space
            child: Column(
              children: [
                ItineraryCard(itinerary: itinerary),
                // ----- ETA between itinerary items -----
                if (!isLast) EtaCard(itinerary: itinerary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
