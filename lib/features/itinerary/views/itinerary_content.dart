import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/itinerary/views/widgets/multi_day_itinerary_list.dart';

class ItineraryContent extends StatelessWidget {
  const ItineraryContent({super.key, required this.listKey});

  final GlobalKey<MultiDayItineraryListState> listKey;

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Column(
      children: [
        MultiDayItineraryList(key: listKey, scrollController: scrollController),
        const SizedBox(height: 40),
        Center(
          child: AppButton.primary(
            onPressed: () {},
            text: "Add Activity",
            icon: Icons.add,
          ),
        ),
        const SizedBox(height: 60),
      ],
    );
  }
}
