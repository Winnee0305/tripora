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
  const ItineraryContent({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Column(
      children: [
        ChangeNotifierProvider(
          create: (_) => WeatherCardViewModel(),
          child: const WeatherCard(),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: AppWidgetStyles.cardDecoration(context),
          child: Row(
            children: [
              AppButton.iconOnly(
                icon: Icons.hotel,
                onPressed: () {},
                iconSize: 18,
                minHeight: 30,
                minWidth: 30,
                backgroundColorOverride: AppColors.accent1.withValues(
                  alpha: 0.1,
                ),
                textColorOverride: AppColors.accent1,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "AMES Hotel",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.weight(ManropeFontWeight.semiBold),
                ),
              ),
              const Text("CHECK IN", style: TextStyle(color: Colors.purple)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        MultiDayItineraryList(scrollController: scrollController),
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
