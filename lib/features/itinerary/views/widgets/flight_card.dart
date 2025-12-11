import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripora/core/models/flight_data.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class FlightCard extends StatelessWidget {
  final FlightData flight;
  final VoidCallback? onTap;

  const FlightCard({super.key, required this.flight, this.onTap});

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd • hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: AppWidgetStyles.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF4A90E2), Color(0xFF357ABD)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flight_takeoff,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        flight.airline,
                        style: theme.textTheme.bodyMedium?.weight(
                          ManropeFontWeight.semiBold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (flight.flightNumber.isNotEmpty)
                        Text(
                          flight.flightNumber,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DEPARTURE",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF4CAF50),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.departureAirport,
                        style: theme.textTheme.bodySmall?.weight(
                          ManropeFontWeight.semiBold,
                        ),
                      ),
                      Text(
                        _formatDateTime(flight.departureDateTime),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ARRIVAL",
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFFFF9800),
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        flight.arrivalAirport,
                        style: theme.textTheme.bodySmall?.weight(
                          ManropeFontWeight.semiBold,
                        ),
                      ),
                      Text(
                        _formatDateTime(flight.arrivalDateTime),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
