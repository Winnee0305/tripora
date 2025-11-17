import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/reusable_widgets/app_expandable_text.dart';
import 'package:tripora/core/reusable_widgets/app_loading_network_image.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';

class ItineraryCard extends StatelessWidget {
  const ItineraryCard({super.key, required this.itinerary});

  final ItineraryData itinerary;
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
            child: SizedBox(
              height: 80,
              width: 80,
              child: AppLoadingNetworkImage(
                imageUrl: itinerary.place?.imageUrl ?? '',
                radius: 14, // optional, controls the loading indicator size
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itinerary.place?.name ?? '',
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
                  children: itinerary.place!.tags.map((tag) {
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

                AppExpandableText(
                  itinerary.userNotes,
                  trimLines: 4,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: ManropeFontWeight.light,
                  ),
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
