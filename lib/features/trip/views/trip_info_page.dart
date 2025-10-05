import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';
import 'package:tripora/features/trip/views/widgets/trip_info/header_section.dart';
import 'package:tripora/features/trip/views/widgets/trip_info/stats_section.dart';

class TripInfoPage extends StatelessWidget {
  const TripInfoPage({
    super.key,
    required this.tripTitle,
    required this.destination,
    required this.startDate,
    required this.endDate,
  });

  final String tripTitle;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TripViewModel(),
      child: Consumer<TripViewModel>(
        builder: (context, vm, child) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top Image + Title Section
                  SizedBox(
                    height: 360,
                    width: double.infinity,
                    child: HeaderSection(vm: vm),
                  ),
                  const StatsSection(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
