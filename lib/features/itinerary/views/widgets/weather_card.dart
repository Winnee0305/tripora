import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:flutter/cupertino.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({
    super.key,
    required this.condition,
    required this.temperature,
    required this.lastUpdated,
  });

  final String condition;
  final double temperature;
  final String lastUpdated;

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  late Timer _timer;
  late DateTime _fetchTimestamp;

  @override
  void initState() {
    super.initState();
    _parseFetchTimestamp();
    // Update every minute to refresh the relative time display
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  void _parseFetchTimestamp() {
    try {
      _fetchTimestamp = DateTime.parse(widget.lastUpdated);
    } catch (e) {
      _fetchTimestamp = DateTime.now();
    }
  }

  @override
  void didUpdateWidget(WeatherCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update timestamp if lastUpdated changed (new data fetched)
    if (oldWidget.lastUpdated != widget.lastUpdated) {
      _parseFetchTimestamp();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  bool get isLoading => widget.condition.isEmpty;

  String _getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(_fetchTimestamp);

    if (difference.inSeconds < 60) {
      return 'Last updated: just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'Last updated: $minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'Last updated: $hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else {
      final days = difference.inDays;
      return 'Last updated: $days ${days == 1 ? 'day' : 'days'} ago';
    }
  }

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
                (widget.condition == "") ? "Loading..." : _getRelativeTime(),
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
              getWeatherConditionIcon(widget.condition),
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(widget.condition, style: theme.textTheme.bodyMedium),
          ],
        ),

        const SizedBox(width: 30),

        // Temperature
        Row(
          children: [
            Icon(CupertinoIcons.thermometer, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              "${widget.temperature.toStringAsFixed(1)}°C",
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
