import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/itinerary/viewmodels/day_selection_viewmodel.dart';
import 'package:tripora/features/itinerary/views/widgets/day_selection_bar.dart';
import 'package:tripora/features/itinerary/views/widgets/weather_card.dart';
import 'package:tripora/features/itinerary/viewmodels/weather_card_viewmodel.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/core/theme/app_colors.dart';
import 'package:tripora/features/itinerary/views/widgets/itinerary_reoderable_list.dart';

// Best Practice: Define heights as constants for robustness and easy updates.
const double _kDragHandleHeight = 4.0;
const double _kDragHandleTopMargin = 12.0;
const double _kDragHandleBottomMargin = 16.0;
const double _kDaySelectorVerticalPadding = 8.0;
const double _kDaySelectorHeight =
    64.0; // Assuming DaySelectionBar has this height

const double _kStickyHeaderHeight =
    _kDragHandleHeight +
    _kDragHandleTopMargin +
    _kDragHandleBottomMargin +
    (_kDaySelectorVerticalPadding * 2) +
    _kDaySelectorHeight; // Calculates to 112.0

class ItineraryPage extends StatefulWidget {
  const ItineraryPage({super.key});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage>
    with SingleTickerProviderStateMixin {
  // State variables for the overscroll effect
  late final AnimationController _animationController;
  late Animation<double> _animation;
  double _dragOffset = 0.0;

  // Store the sheet's min size for easy access
  final double _minSheetSize = 0.35;

  // Keep track of the sheet's current size
  double _currentSheetSize = 0.55; // Start with initial size

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // A function to run the snap-back animation
  void _runAnimation() {
    _animation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut, // A nice bouncy curve
      ),
    );

    _animationController.reset();
    _animationController.forward();
  }

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
            // ---------- MAP BACKGROUND ----------
            Positioned.fill(
              child: Image.asset(
                "assets/images/exp_map.png",
                fit: BoxFit.cover,
              ),
            ),

            // ---------- BACK BUTTON ----------
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton.iconOnly(
                      icon: CupertinoIcons.back,
                      onPressed: () => Navigator.pop(context),
                      backgroundVariant: BackgroundVariant.secondaryFilled,
                    ),
                    AppButton.textOnly(
                      text: 'Melaka 2 days family trip',
                      textStyleOverride: theme.textTheme.headlineSmall?.weight(
                        ManropeFontWeight.semiBold,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      radius: 30,
                      backgroundVariant: BackgroundVariant.secondaryTrans,
                      onPressed: () {},
                    ),
                    AppButton.iconOnly(
                      icon: CupertinoIcons.home,
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      backgroundVariant: BackgroundVariant.secondaryFilled,
                    ),
                  ],
                ),
              ),
            ),

            // ---------- DRAGGABLE SHEET with OVERSCROLL EFFECT ----------
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                if (_animationController.isAnimating) {
                  _dragOffset = _animation.value;
                }
                return Transform.translate(
                  offset: Offset(0, _dragOffset),
                  child: child,
                );
              },
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (_currentSheetSize <= _minSheetSize &&
                      details.delta.dy > 0) {
                    setState(() {
                      _dragOffset += details.delta.dy * 0.4; // Resistance
                    });
                  }
                },
                onVerticalDragEnd: (details) {
                  if (_dragOffset > 0) {
                    _runAnimation();
                  }
                },
                child: NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    _currentSheetSize = notification.extent;
                    return true;
                  },
                  child: DraggableScrollableSheet(
                    initialChildSize: _currentSheetSize,
                    minChildSize: _minSheetSize,
                    maxChildSize: 0.85,
                    snap: true,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: AppWidgetStyles.cardDecoration(context)
                            .copyWith(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(48),
                              ),
                            ),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            // ----- Combined Sticky Header -----
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _StickyHeaderDelegate(
                                child: Container(
                                  color: theme.colorScheme.surface,
                                  child: Column(
                                    children: [
                                      // Drag Handle
                                      Container(
                                        width: 40,
                                        height: _kDragHandleHeight,
                                        margin: const EdgeInsets.only(
                                          top: _kDragHandleTopMargin,
                                          bottom: _kDragHandleBottomMargin,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                      // Day Selection Bar
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical:
                                              _kDaySelectorVerticalPadding,
                                        ),
                                        child: const SizedBox(
                                          height: _kDaySelectorHeight,
                                          child: DaySelectionBar(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // ----- Rest of Scrollable Content -----
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                                child: Column(
                                  children: [
                                    ChangeNotifierProvider(
                                      create: (_) => WeatherCardViewModel(),
                                      child: const WeatherCard(),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration:
                                          AppWidgetStyles.cardDecoration(
                                            context,
                                          ),
                                      child: Row(
                                        children: [
                                          AppButton.iconOnly(
                                            icon: Icons.hotel,
                                            onPressed: () {},
                                            iconSize: 18,
                                            minHeight: 30,
                                            minWidth: 30,
                                            backgroundColorOverride: AppColors
                                                .accent1
                                                .withValues(alpha: 0.1),
                                            textColorOverride:
                                                AppColors.accent1,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "AMES Hotel",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.weight(
                                                    ManropeFontWeight.semiBold,
                                                  ),
                                            ),
                                          ),
                                          const Text(
                                            "CHECK IN",
                                            style: TextStyle(
                                              color: Colors.purple,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    const ItineraryReorderableList(),
                                    const SizedBox(height: 40),
                                    Center(
                                      child: AppButton.primary(
                                        onPressed: () {},
                                        text: "Add Activity",
                                        icon: Icons.add,
                                      ),
                                    ),
                                    const SizedBox(height: 60),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Sticky Header Delegate ----------
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => _kStickyHeaderHeight;
  @override
  double get maxExtent => _kStickyHeaderHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) =>
      child != oldDelegate.child;
}
