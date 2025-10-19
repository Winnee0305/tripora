import 'package:flutter/material.dart';
import 'package:tripora/features/trip/views/widgets/trip_info_card.dart';

class ProfileSharedTripsContent extends StatelessWidget {
  const ProfileSharedTripsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          TripInfoCard(
            image: const AssetImage("assets/images/exp_melaka_trip.png"),
            startDate: DateTime(2025, 8, 13),
            endDate: DateTime(2025, 8, 14),
            tripTitle: "Melaka Trip",
            destination: "Melaka, Malaysia",
          ),
        ],
      ),
    );
  }
}
