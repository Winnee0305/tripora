import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';

class ItineraryCard extends StatelessWidget {
  const ItineraryCard({super.key, required this.item});

  final Itinerary item;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
                      backgroundVariant: BackgroundVariant.primaryTrans,
                      textStyleOverride: theme.textTheme.labelMedium,
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
                    if (item.estimatedDuration.isEmpty == false) ...[
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
    );
  }
}
