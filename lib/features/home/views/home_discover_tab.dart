import 'package:flutter/material.dart';
import 'package:tripora/features/home/views/widgets/discover_continue_trip_section.dart';
import 'package:tripora/features/home/views/widgets/discover_make_bookings_section.dart';
import 'package:tripora/features/home/views/widgets/discover_recommendation_section.dart';
import 'package:flutter/cupertino.dart';

class HomeDiscoverTab extends StatelessWidget {
  const HomeDiscoverTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              children: [
                DiscoverMakeBookingsSection(),
                SizedBox(height: 38),
                DiscoverContinueTripSection(),
              ],
            ),
          ),
          SizedBox(height: 38),
          DiscoverRecommendationSection(),
        ],
      ),
    );
  }
}
