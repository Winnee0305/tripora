import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';
import 'package:tripora/features/trip/views/widgets/trip_info_card.dart';
import 'package:provider/provider.dart';
import 'trip_dashboard_page.dart';
import 'create_edit_trip_page.dart';

class TripPage extends StatelessWidget {
  const TripPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tripVm = context.watch<TripViewModel>();
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Trips',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  AppButton.primary(
                    text: 'Create Trip',
                    icon: CupertinoIcons.plus,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                            value: tripVm,
                            child: const CreateEditTripPage(),
                          ),
                        ),
                      ).then((_) => tripVm.loadTrips());
                    },
                    minWidth: 140,
                    radius: 10,
                    textStyleOverride: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: ManropeFontWeight.regular),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: tripVm.trips.map((trip) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: () {
                            tripVm.setSelectedTrip(trip);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider.value(
                                  value:
                                      tripVm, // reuse the existing TripViewModel
                                  child: TripDashboardPage(),
                                ),
                              ),
                            );
                          },
                          child: TripInfoCard(
                            imageUrl: trip.tripImageUrl,
                            startDate: trip.startDate!,
                            endDate: trip.endDate!,
                            tripTitle: trip.tripName,
                            destination: trip.destination,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
