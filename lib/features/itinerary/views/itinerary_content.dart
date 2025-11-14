import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/utils/constants.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/itinerary/viewmodels/weather_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/multi_day_itinerary_list.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';

class ItineraryContent extends StatelessWidget {
  const ItineraryContent({super.key, required this.listKey});

  final GlobalKey<MultiDayItineraryListState> listKey;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    final vm = context.watch<ItineraryViewModel>();
    final tripVm = context.watch<TripViewModel>();
    final destination = destinationsImageCoordinates.firstWhere(
      (element) => element['destination'] == tripVm.trip!.destination,
    );

    return Column(
      children: [
        ChangeNotifierProvider(
          create: (context) {
            final weatherVm = WeatherViewModel(
              dates: vm.itinerariesMap.keys
                  .map(
                    (day) => vm.trip!.startDate!.add(Duration(days: day - 1)),
                  )
                  .toList(),
              latitude: destination['lat'] as double,
              longitude: destination['lng'] as double,
            );

            // Fetch forecasts after first frame
            WidgetsBinding.instance.addPostFrameCallback((_) {
              weatherVm.fetchForecasts();
            });

            return weatherVm;
          },
          child: MultiDayItineraryList(
            key: listKey,
            scrollController: scrollController,
          ),
        ),

        // MultiDayItineraryList(key: listKey, scrollController: scrollController),
        const SizedBox(height: 40),
        // Center(
        //   child: AppButton.primary(
        //     onPressed: () {},
        //     text: "Add Activity",
        //     icon: Icons.add,
        //   ),
        // ),
        // const SizedBox(height: 60),
      ],
    );
  }
}
