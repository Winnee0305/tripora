import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/navigation/viewmodels/navigation_viewmodel.dart';
import 'package:tripora/features/trip/models/trip_data.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart'
    show TripViewModel;
import 'package:tripora/features/trip/views/trip_info_page.dart';
import 'package:tripora/features/trip/views/widgets/trip_info_card.dart';

class ContinueTripSection extends StatelessWidget {
  const ContinueTripSection({super.key});

  @override
  Widget build(BuildContext context) {
    final tripVm = context.watch<TripViewModel>();

    final hasTrips = tripVm.trips.isNotEmpty;
    final firstTrip = hasTrips ? tripVm.trips.first : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
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

              GestureDetector(
                onTap: () {
                  final navVm = context.read<NavigationViewModel>();
                  navVm.goToTripPage(); // switches to TripPage
                },
                child: Text(
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
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Show first trip or a placeholder button
          hasTrips
              ? GestureDetector(
                  onTap: () {
                    tripVm.setSelectedTrip(firstTrip);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider.value(
                          value: tripVm, // reuse the existing TripViewModel
                          child: TripDashboardPage(),
                        ),
                      ),
                    );
                  },
                  child: TripInfoCard(
                    imageUrl: firstTrip!.tripImageUrl,
                    startDate: firstTrip.startDate ?? DateTime.now(),
                    endDate: firstTrip.endDate ?? DateTime.now(),
                    tripTitle: firstTrip.tripName,
                    destination: firstTrip.destination,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    AppButton.textOnly(
                      onPressed: () {
                        final navVm = context.read<NavigationViewModel>();
                        navVm.goToTripPage();
                      },
                      text: "You have no created trip, create now",
                      backgroundVariant: BackgroundVariant.primaryTrans,
                      radius: 10,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
