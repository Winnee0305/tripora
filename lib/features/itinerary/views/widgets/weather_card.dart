import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/itinerary/viewmodels/weather_card_viewmodel.dart';
import 'package:flutter/cupertino.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WeatherCardViewModel>();
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: AppWidgetStyles.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Weather Forecast", style: theme.textTheme.titleLarge),
              Text(
                "Last updated: ${vm.lastUpdated}",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: ManropeFontWeight.light,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Main weather row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                // ----- Cndition
                children: [
                  Icon(vm.getConditionIcon, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(vm.condition, style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(width: 30),
              Row(
                // ----- Temperature
                children: [
                  Icon(
                    CupertinoIcons.thermometer,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${vm.temperature.toStringAsFixed(1)}°C",
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
