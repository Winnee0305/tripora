import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/trip/views/trip_info_page.dart';
import 'package:tripora/core/utils/format_utils.dart';

class TripInfoCard extends StatelessWidget {
  final AssetImage image;
  final DateTime startDate;
  final DateTime endDate;
  final String tripTitle;
  final String destination;

  const TripInfoCard({
    super.key,
    required this.image,
    required this.startDate,
    required this.endDate,
    required this.tripTitle,
    required this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TripInfoPage(
              tripTitle: tripTitle,
              destination: destination,
              startDate: startDate,
              endDate: endDate,
            ),
          ),
        );
      },
      child: Container(
        decoration: AppWidgetStyles.cardDecoration(
          context,
        ).copyWith(borderRadius: BorderRadius.circular(18)),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            Container(
              width: 118,
              height: 94,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(image: image, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 14),

            // Trip Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date Range
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 12,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        formatDateRange(startDate, endDate),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: ManropeFontWeight.light,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Trip Title
                  Text(
                    tripTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Destination
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.placemark_fill,
                        size: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        destination,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withValues(alpha: 0.6),
                              fontWeight: ManropeFontWeight.light,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
