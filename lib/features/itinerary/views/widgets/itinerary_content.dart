import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/features/itinerary/views/widgets/multi_day_itinerary_list.dart';
import 'package:tripora/features/itinerary/views/widgets/weather_card.dart';
import 'package:tripora/features/itinerary/viewmodels/weather_card_viewmodel.dart';

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
