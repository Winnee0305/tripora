import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/utils/constants.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/itinerary/viewmodels/post_itinerary_view_model.dart';
import 'package:tripora/features/itinerary/viewmodels/weather_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/multi_day_itinerary_list.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';

class ItineraryContent extends StatelessWidget {
  const ItineraryContent({
    super.key,
    required this.listKey,
    this.isViewMode = false,
  });

  final GlobalKey<MultiDayItineraryListState> listKey;
  final bool isViewMode;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();

    // Get data based on view mode
    final Map<int, dynamic> itinerariesMap;
    final DateTime? startDate;
    final String? destinationName;

    if (isViewMode) {
      final postVm = context.watch<PostItineraryViewModel>();
      itinerariesMap = postVm.itinerariesMap;
      startDate = postVm.trip?.startDate;
      destinationName = postVm.trip?.destination;
    } else {
      final vm = context.watch<ItineraryViewModel>();
      final tripVm = context.watch<TripViewModel>();
      itinerariesMap = vm.itinerariesMap;
      startDate = vm.trip?.startDate;
      destinationName = tripVm.trip?.destination;
    }

    final destination = destinationsImageCoordinates.firstWhere(
      (element) => element['destination'] == destinationName,
      orElse: () => destinationsImageCoordinates.first,
    );

    return Column(
      children: [
        ChangeNotifierProvider(
          create: (context) {
            final weatherVm = WeatherViewModel(
              dates: itinerariesMap.keys
                  .map((day) => startDate!.add(Duration(days: day - 1)))
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
            isViewMode: isViewMode,
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
