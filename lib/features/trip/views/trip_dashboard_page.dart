import 'package:flutter/material.dart';
import 'package:tripora/features/trip/views/widgets/trip_info/header_section.dart';
import 'package:tripora/features/trip/views/widgets/trip_info/stats_section.dart';
import 'package:tripora/features/trip/views/widgets/etiquette_education_section.dart';

class TripDashboardPage extends StatelessWidget {
  const TripDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 20),
            const StatsSection(),
            const SizedBox(height: 20),

            /// Etiquette Education Section
            const EtiquetteEducationSection(),
            // You can add more sections here that consume the providers
          ],
        ),
      ),
    );
  }
}
