import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/itinerary/views/widgets/day_selection_bar.dart';

class ItineraryHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 300; // collapsed height
  @override
  double get maxExtent => 400; // expanded height

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    // Interpolate image height factor: 0.6 (expanded) → 1.0 (collapsed)
    final imageHeightFactor = 0.84 + (0.1 * progress);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// Background Image that grows as you scroll up
          Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
              heightFactor: imageHeightFactor, // 👈 dynamic factor
              widthFactor: 1,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  "assets/images/exp_map.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          /// Foreground UI
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // --- Top Bar ---
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 10,
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
                          textStyleOverride: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.weight(ManropeFontWeight.semiBold),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          radius: 30,
                          backgroundVariant: BackgroundVariant.secondaryTrans,
                          onPressed: () {},
                        ),
                        AppButton.iconOnly(
                          icon: CupertinoIcons.home,
                          onPressed: () {
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          },
                          backgroundVariant: BackgroundVariant.secondaryFilled,
                        ),
                      ],
                    ),
                  ),
                ),

                // --- Bottom bar ---
                Container(
                  padding: EdgeInsets.only(bottom: 0),
                  child: DaySelectionBar(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
