import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/widgets/pin_icon.dart';
import 'package:tripora/core/services/map_service.dart';

class ItineraryCard extends StatelessWidget {
  final Itinerary item;
  final bool isFirst;
  final bool isLast;
  final int index;

  const ItineraryCard({
    super.key,
    required this.item,
    this.isFirst = false,
    this.isLast = false,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ----- Timeline indicator
          SizedBox(
            width: 20,
            child: Column(
              children: [
                // The top line
                if (!isFirst)
                  Container(
                    width: 1,
                    height: 4,
                    color: theme.colorScheme.secondary.withValues(alpha: 0.6),
                  )
                else
                  (Container(width: 2, height: 4, color: Colors.transparent)),

                // The pin icon
                PinIcon(
                  number: (index + 1).toString(),
                  color: AppColors.design3,
                ),

                // The bottom line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: theme.colorScheme.secondary.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12), // Space between timeline and card
          // ----- Card content
          Expanded(
            // Take the remaining horizontal space
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: AppWidgetStyles.cardDecoration(context),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset(
                          item.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.destination,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: item.tags.map((tag) {
                                return AppButton.textOnly(
                                  text: tag,
                                  onPressed: () {},
                                  minHeight: 10,
                                  minWidth: 0,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  backgroundVariant:
                                      BackgroundVariant.primaryTrans,
                                  textStyleOverride:
                                      theme.textTheme.labelMedium,
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (item.estimatedCost.isEmpty == false) ...[
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.money_dollar,
                                        color: theme.colorScheme.onSurface,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.estimatedCost,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(width: 22),
                                if (item.estimatedDuration.isEmpty ==
                                    false) ...[
                                  Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.clock,
                                        color: theme.colorScheme.onSurface,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        item.estimatedDuration,
                                        style: theme.textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        CupertinoIcons.line_horizontal_3,
                        color: theme.colorScheme.onSurface,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                // ----- ETA between itinerary items -----
                if (!isLast)
                  Container(
                    padding: const EdgeInsets.only(
                      left: 14,
                      top: 20,
                      bottom: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          CupertinoIcons.ellipsis_vertical,
                          color: theme.colorScheme.onSurface,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          item.travelStyle == TravelStyle.driving
                              ? CupertinoIcons.car
                              : item.travelStyle == TravelStyle.walking
                              ? CupertinoIcons.person
                              : Icons.directions_bike,
                          color: theme.colorScheme.onSurface,
                          size: 22,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${item.routeInfo?.eta.inHours}h ${item.routeInfo?.eta.inMinutes.remainder(60)}m",
                        ),
                        const SizedBox(width: 12),
                        Icon(
                          CupertinoIcons.circle_fill,
                          color: theme.colorScheme.onSurface,
                          size: 4,
                        ),
                        const SizedBox(width: 12),
                        Text("${item.routeInfo?.distanceKm.toString()} km"),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            "Directions",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
