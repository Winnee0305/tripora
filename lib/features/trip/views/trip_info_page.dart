import 'package:flutter/material.dart';
import 'package:tripora/features/trip/views/widgets/trip_info/header_section.dart';
import 'package:tripora/features/trip/views/widgets/trip_info/stats_section.dart';

class TripInfoPage extends StatelessWidget {
  const TripInfoPage({super.key});

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
            const StatsSection(),
          ],
        ),
      ),
    );
  }
}
