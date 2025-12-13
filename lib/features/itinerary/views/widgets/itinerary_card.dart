import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/reusable_widgets/app_expandable_text.dart';
import 'package:tripora/core/reusable_widgets/app_loading_network_image.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/poi/views/poi_page.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class ItineraryCard extends StatelessWidget {
  const ItineraryCard({
    super.key,
    required this.itinerary,
    this.showDragHandle,
  });

  final ItineraryData itinerary;
  final bool? showDragHandle;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // If it's a note, show compact sticky note card
    if (itinerary.isNote) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(
            0xFFFFF9E6,
          ).withOpacity(0.7), // Semi-transparent yellow
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFFFE082).withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Note icon - smaller and simpler
            Icon(Icons.sticky_note_2, color: const Color(0xFFFFB300), size: 18),
            const SizedBox(width: 10),
            // Note content
            Expanded(
              child: Text(
                itinerary.userNotes.isEmpty
                    ? 'Empty note'
                    : itinerary.userNotes,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: itinerary.userNotes.isEmpty
                      ? Colors.black54
                      : Colors.black87,
                  fontStyle: itinerary.userNotes.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Drag handle - more subtle
            if (showDragHandle ?? false)
              Icon(Icons.drag_indicator, color: Colors.black26, size: 16),
          ],
        ),
      );
    }

    // Regular destination card
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppWidgetStyles.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: itinerary.place != null
                    ? () {
                        final userVm = context.read<UserViewModel>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PoiPage(
                              placeId: itinerary.place!.id,
                              userId: userVm.user?.uid,
                            ),
                          ),
                        );
                      }
                    : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: AppLoadingNetworkImage(
                      imageUrl: itinerary.place?.imageUrl ?? '',
                      radius:
                          14, // optional, controls the loading indicator size
                    ),
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
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 20,
                      padding: const EdgeInsets.only(right: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: (itinerary.place?.tags ?? []).map((tag) {
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
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              if (showDragHandle ?? true)
                Icon(
                  CupertinoIcons.line_horizontal_3,
                  color: theme.colorScheme.onSurface,
                  size: 20,
                ),
            ],
          ),
          SizedBox(height: 12),
          AppExpandableText(
            itinerary.userNotes,
            trimLines: 4,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: ManropeFontWeight.light,
            ),
          ),
        ],
      ),
    );
  }
}
