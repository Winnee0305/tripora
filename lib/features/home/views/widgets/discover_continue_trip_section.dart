import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/trip/views/widgets/trip_info_card.dart';

class DiscoverContinueTripSection extends StatelessWidget {
  const DiscoverContinueTripSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Continue Edit Your Trip",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              "View All",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
                fontWeight: ManropeFontWeight.regular,
                decoration: TextDecoration.underline,
                decorationThickness: 0.8,
                decorationColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Reusable trip info card
        TripInfoCard(
          image: AssetImage("assets/images/exp_melaka_trip.png"),
          startDate: DateTime(2025, 8, 13),
          endDate: DateTime(2025, 8, 14),
          tripTitle: "Melaka Trip",
          destination: "Melaka, Malaysia",
        ),
      ],
    );
  }
}
