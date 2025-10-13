import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/itinerary/viewmodels/day_selection_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_header_section.dart';
import 'package:tripora/features/itinerary/views/widgets/day_selection_bar.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_content.dart';

class ItineraryPage extends StatelessWidget {
  const ItineraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => DaySelectionViewModel(
        startDate: DateTime(2025, 10, 6),
        endDate: DateTime(2025, 10, 12),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            // ----- Map Background
            Positioned.fill(
              child: Image.asset(
                "assets/images/exp_map.png",
                fit: BoxFit.cover,
              ),
            ),

            // ------ Back button, title, home button
            ItineraryHeaderSection(),

            // ------ Draggable Scrollable Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.5,
              minChildSize: 0.11,
              maxChildSize: 0.85,
              snap: false,
              builder: (context, scrollController) {
                // ----- The white rounded container -----
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  decoration: AppWidgetStyles.cardDecoration(context).copyWith(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(48),
                    ),
                    color: theme.scaffoldBackgroundColor,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(48),
                    ),
                    child: CustomScrollView(
                      controller: scrollController,
                      slivers: [
                        // ---------- Sticky Drag Handle ----------
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _StickyHeaderDelegate(
                            height: 20,
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              alignment: Alignment.center,
                              child: Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ---------- Title (not sticky) ----------
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 30,
                              right: 30,
                              top: 0,
                              bottom: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Melaka 2 Days Family Trip",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.weight(ManropeFontWeight.semiBold),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      "6 - 12 October 2025",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "6 Days, 5 Nights",
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurface
                                                .withOpacity(0.6),
                                          ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      CupertinoIcons.chevron_right,
                                      size: 12,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.6),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // ---------- Sticky Day Selection Bar ----------
                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _StickyHeaderDelegate(
                            height: 86,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              color: Theme.of(
                                context,
                              ).colorScheme.surface, // or any color
                              child: const DaySelectionBar(),
                            ),
                          ),
                        ),

                        // ---------- Main Content (scrollable itinerary for each day)----------
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: ItineraryContent(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;
  final Color? backgroundColor;

  _StickyHeaderDelegate({
    required this.child,
    required this.height,
    this.backgroundColor,
  });

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: height,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child ||
        oldDelegate.height != height ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
