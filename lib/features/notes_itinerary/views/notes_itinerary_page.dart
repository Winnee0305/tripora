import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/day_selection_viewmodel.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/itinerary/views/widgets/map_screen.dart';
import 'package:tripora/features/notes_itinerary/views/widgets/notes_itinerary_page_header_section.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/app_special_tab_n_day_selection_bar.dart';
import 'package:tripora/features/itinerary/views/itinerary_content.dart';
import 'package:tripora/features/itinerary/views/widgets/multi_day_itinerary_list.dart';
import 'package:tripora/features/notes/views/notes_content.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';

class NotesItineraryPage extends StatelessWidget {
  NotesItineraryPage({super.key, required this.currentTab});

  // The listKey is final, so it can be used inside a StatelessWidget
  final GlobalKey<MultiDayItineraryListState> _listKey =
      GlobalKey<MultiDayItineraryListState>();

  final int currentTab;

  final List<LatLng> melaccaAttractions = [
    // 1. A Famosa Fort
    LatLng(2.1896, 102.2501),

    // 2. St. Paul's Church
    LatLng(2.1893, 102.2505),

    // 3. Jonker Street
    LatLng(2.1920, 102.2495),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripVm = context.watch<TripViewModel>();
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ----- Map Background -----
          Positioned.fill(
            child: Image.asset("assets/images/exp_map.png", fit: BoxFit.cover),
          ),
          // Positioned.fill(child: MapScreen(destinations: melaccaAttractions)),

          // ----- Header (Back, Home, etc.)
          const NotesItineraryPageHeaderSection(),

          // ----- Draggable Sheet -----
          DraggableScrollableSheet(
            initialChildSize: 0.5,
            minChildSize: 0.12,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
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
                  child: Consumer<DaySelectionViewModel>(
                    builder: (context, vm, _) {
                      return CustomScrollView(
                        controller: scrollController,
                        slivers: [
                          // ---------- Sticky Handle ----------
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _StickyHeaderDelegate(
                              height: 20,
                              child: Container(
                                alignment: Alignment.center,
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
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

                          // ---------- Title ----------
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 30,
                                right: 30,
                                top: 4,
                                bottom: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tripVm.trip!.tripName,
                                    style: theme.textTheme.headlineMedium
                                        ?.weight(ManropeFontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        formatDateRangeWords(
                                          tripVm.trip!.startDate!,
                                          tripVm.trip!.endDate!,
                                        ),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.6),
                                            ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        CupertinoIcons.circle_fill,
                                        size: 4,
                                        color: theme.colorScheme.onSurface
                                            .withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        calculateTripDuration(
                                          tripVm.trip!.startDate!,
                                          tripVm.trip!.endDate!,
                                        ),
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.6),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ---------- Sticky Selection Bar ----------
                          SliverPersistentHeader(
                            pinned: true,
                            delegate: _StickyHeaderDelegate(
                              height: 86,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                color: theme.colorScheme.surface,
                                child: AppSpecialTabNDaySelectionBar(
                                  listKey: _listKey,
                                  firstTabLabel: 'Notes',

                                  color: AppColors.design2,
                                ),
                              ),
                            ),
                          ),

                          // ---------- Main Content ----------
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                switchInCurve: Curves.easeInOut,
                                child: vm.selectedDay == 0
                                    ? const NotesContent()
                                    : ItineraryContent(listKey: _listKey),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      // ),
    );
  }
}

// ---------- Sticky Header Delegate ----------
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
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) =>
      oldDelegate.child != child ||
      oldDelegate.height != height ||
      oldDelegate.backgroundColor != backgroundColor;
}
