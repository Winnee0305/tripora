import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_page_viewmodel.dart';
import 'package:tripora/features/trip/views/widgets/trip_info/header_section.dart';
import 'package:tripora/features/trip/views/widgets/trip_info/stats_section.dart';

class TripDashboardPage extends StatelessWidget {
  const TripDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ItineraryPageViewModel()),
        // ChangeNotifierProvider(create: (_) => ItineraryContentViewModel()),
        // ChangeNotifierProvider(create: (_) => ExpenseViewModel(tripId: tripId)),
        // ChangeNotifierProvider(create: (_) => PoiViewModel(tripId: tripId)),
      ],
      child: Builder(
        builder: (context) {
          // All providers are available here
          final itineraryVm = context.watch<ItineraryPageViewModel>();
          // final itineraryContentVm = context.watch<ItineraryPageViewModel>();
          // final expenseVm = context.watch<ExpenseViewModel>();
          // final poiVm = context.watch<PoiViewModel>();

          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Image + Title Section
                  SizedBox(
                    height: 360,
                    width: double.infinity,
                    child: HeaderSection(),
                  ),
                  const StatsSection(),
                  // You can add more sections here that consume the providers
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
