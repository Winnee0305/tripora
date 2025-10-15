import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/features/trip/viewmodels/create_trip_viewmodel.dart';
import 'package:tripora/features/trip/views/widgets/trip_info_card.dart';
import 'package:provider/provider.dart';
import 'trip_info_page.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';
import 'create_trip_page.dart';

class TripPage extends StatelessWidget {
  const TripPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      // Navigate to Create Trip Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider(
                            create: (_) => CreateTripViewModel(),
                            child: const CreateTripPage(),
                          ),
                        ),
                      );
                    },
                    minWidth: 140,
                    radius: 10,
                    textStyleOverride: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontWeight: ManropeFontWeight.regular),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (_) => TripViewModel(),
                              child: TripInfoPage(
                                tripTitle: "Melaka Trip",
                                destination: "Melaka, Malaysia",
                                startDate: DateTime(2025, 8, 13),
                                endDate: DateTime(2025, 8, 14),
                              ),
                            ),
                          ),
                        );
                      },
                      child: TripInfoCard(
                        image: AssetImage("assets/images/exp_melaka_trip.png"),
                        startDate: DateTime(2025, 8, 13),
                        endDate: DateTime(2025, 8, 14),
                        tripTitle: "Melaka Trip",
                        destination: "Melaka, Malaysia",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
