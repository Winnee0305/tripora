import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:flutter/cupertino.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    required this.condition,
    required this.temperature,
    required this.lastUpdated,
  });

  final String condition;
  final double temperature;
  final String lastUpdated;

  bool get isLoading => condition.isEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: AppWidgetStyles.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Weather Forecast", style: theme.textTheme.titleLarge),
              Text(
                (condition == "") ? "Loading..." : "Last updated: $lastUpdated",
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  fontWeight: ManropeFontWeight.light,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ----- Animated Main Row -----
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: isLoading ? _buildLoading() : _buildWeather(theme),
          ),
        ],
      ),
    );
  }

  // ---------------- UI Blocks ----------------

  Widget _buildLoading() {
    return SizedBox(
      key: const ValueKey('loading'),
      height: 24,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [CupertinoActivityIndicator(radius: 8)],
      ),
    );
  }

  Widget _buildWeather(ThemeData theme) {
    return Row(
      key: const ValueKey('weather'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Condition
        Row(
          children: [
            Icon(
              getWeatherConditionIcon(condition),
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(condition, style: theme.textTheme.bodyMedium),
          ],
        ),

        const SizedBox(width: 30),

        // Temperature
        Row(
          children: [
            Icon(CupertinoIcons.thermometer, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              "${temperature.toStringAsFixed(1)}°C",
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
