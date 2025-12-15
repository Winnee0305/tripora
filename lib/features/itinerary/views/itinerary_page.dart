import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/day_selection_viewmodel.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_page_header_section.dart';
import 'package:tripora/core/reusable_widgets/app_special_tab_n_day_selection_bar/app_special_tab_n_day_selection_bar.dart';
import 'package:tripora/features/itinerary/views/itinerary_content.dart';
import 'package:tripora/features/itinerary/viewmodels/itinerary_view_model.dart';
import 'package:tripora/features/itinerary/viewmodels/post_itinerary_view_model.dart';
import 'package:tripora/features/itinerary/views/widgets/ai_plan_button.dart';
import 'package:tripora/features/itinerary/views/widgets/multi_day_itinerary_list.dart';
import 'package:tripora/features/trip/viewmodels/trip_viewmodel.dart';
import 'package:tripora/features/user/viewmodels/user_viewmodel.dart';

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({
    super.key,
    required this.currentTab,
    this.isViewMode = false,
  });

  final int currentTab;
  final bool isViewMode;

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  // The listKey is final, so it can be used inside a StatelessWidget
  final GlobalKey<MultiDayItineraryListState> _listKey =
      GlobalKey<MultiDayItineraryListState>();

  // Position for draggable FAB (will be initialized in build)
  Offset? _fabPosition;

  // ----- Dummy Data for Map -----
  final List<LatLng> melaccaAttractions = [
    // 1. A Famosa Fort
    LatLng(2.1896, 102.2501),

    // 2. St. Paul's Church
    LatLng(2.1893, 102.2505),

    // 3. Jonker Street
    LatLng(2.1920, 102.2495),
  ];

  void _handleAIPlan(BuildContext context) async {
    final itineraryVm = context.read<ItineraryViewModel>();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Generating AI itinerary plan...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );

    // Generate and apply AI plan using ViewModel
    final success = await itineraryVm.generateAndApplyAIPlan();

    // Close loading dialog and wait for frame to complete
    if (context.mounted) {
      Navigator.of(context).pop();
    }

    // Wait for next frame before showing result to avoid layout conflicts
    await Future.delayed(const Duration(milliseconds: 100));

    // Show result message
    if (context.mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('AI itinerary plan generated successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            action: SnackBarAction(
              label: 'SYNC',
              textColor: Theme.of(context).colorScheme.onPrimary,
              onPressed: () {
                itineraryVm.syncItineraries();
              },
            ),
          ),
        );
      } else {
        final errorMsg = itineraryVm.error ?? 'Failed to generate AI plan';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripVm = context.watch<TripViewModel>();
    final userVm = context.read<UserViewModel>();
    final screenSize = MediaQuery.of(context).size;

    // Get post data if in view mode
    final postData = widget.isViewMode
        ? context.read<PostItineraryViewModel>().postData
        : null;
    final postId = postData?.postId;
    final authorName = postData?.userName;
    final authorImageUrl = postData?.userImageUrl;
    final collectsCount = postData?.collectsCount ?? 0;

    // Initialize FAB position if not set (bottom-right corner with padding)
    _fabPosition ??= Offset(screenSize.width - 80, screenSize.height - 180);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ----- Map Background -----
          Positioned.fill(
            child: Image.asset("assets/images/exp_map.png", fit: BoxFit.cover),
          ),
          // Positioned.fill(
          //   child: MapScreen(destinations: itineraryVm.getItineraryLatLngs()),
          // ),

          // ----- Header (Back, Home, etc.)
          ItineraryPageHeaderSection(
            userVm: userVm,
            isViewMode: widget.isViewMode,
            postId: postId,
            authorName: authorName,
            authorImageUrl: authorImageUrl,
            collectsCount: collectsCount,
          ),

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
                                child: ItineraryContent(
                                  listKey: _listKey,
                                  isViewMode: widget.isViewMode,
                                ),
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

          // ----- Draggable AI Button (on top of everything) -----
          if (!widget.isViewMode)
            Positioned(
              left: _fabPosition!.dx,
              top: _fabPosition!.dy,
              child: Draggable(
                feedback: Material(
                  color: Colors.transparent,
                  child: Opacity(
                    opacity: 0.8,
                    child: AIPlanButton(onPressed: () {}),
                  ),
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  setState(() {
                    // Constrain position within screen bounds
                    _fabPosition = Offset(
                      details.offset.dx.clamp(0, screenSize.width - 80),
                      details.offset.dy.clamp(0, screenSize.height - 80),
                    );
                  });
                },
                child: AIPlanButton(onPressed: () => _handleAIPlan(context)),
              ),
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

  _StickyHeaderDelegate({required this.child, required this.height});

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
      child: Material(color: Colors.transparent, child: child),
    );
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.height != height;
}
