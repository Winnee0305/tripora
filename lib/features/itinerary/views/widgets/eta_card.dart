import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/models/itinerary_data.dart';

class EtaCard extends StatelessWidget {
  const EtaCard({super.key, required this.itinerary});

  final ItineraryData itinerary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(left: 14, top: 20, bottom: 20),

      // child: Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     Icon(
      //       CupertinoIcons.ellipsis_vertical,
      //       color: theme.colorScheme.onSurface,
      //       size: 20,
      //     ),
      //     const SizedBox(width: 6),
      //     Icon(
      //       item.travelStyle == TravelStyle.driving
      //           ? CupertinoIcons.car
      //           : item.travelStyle == TravelStyle.walking
      //           ? CupertinoIcons.person
      //           : Icons.directions_bike,
      //       color: theme.colorScheme.onSurface,
      //       size: 22,
      //     ),
      //     const SizedBox(width: 6),
      //     Text(
      //       "${item.routeInfo?.eta.inHours}h ${item.routeInfo?.eta.inMinutes.remainder(60)}m",
      //     ),
      //     const SizedBox(width: 12),
      //     Icon(
      //       CupertinoIcons.circle_fill,
      //       color: theme.colorScheme.onSurface,
      //       size: 4,
      //     ),
      //     const SizedBox(width: 12),
      //     Text("${item.routeInfo?.distanceKm.toString()} km"),
      //     const SizedBox(width: 20),
      //     GestureDetector(
      //       onTap: () {},
      //       child: Text(
      //         "Directions",
      //         style: theme.textTheme.bodyMedium?.copyWith(
      //           fontWeight: FontWeight.bold,
      //           decoration: TextDecoration.underline,
      //           color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
      //         ),
      //       ),
      //     ),
      //   ],
    );
  }
}
