// views/place_detail_page.dart
import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import '../viewmodels/poi_page_viewmodel.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class PoiHeaderScreen extends StatelessWidget {
  final PoiPageViewmodel vm;
  const PoiHeaderScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10), // outer spacing
          child: ClipRRect(
            borderRadius: BorderRadius.circular(58), // adjust radius
            child: Image.asset(
              vm.place.image,
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // ---- Top Buttons
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppButton.iconOnly(
                  icon: CupertinoIcons.back,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundVariant: BackgroundVariant.secondaryFilled,
                ),
                AppButton.iconOnly(
                  icon: CupertinoIcons.heart,
                  onPressed: () {},
                  backgroundVariant: BackgroundVariant.secondaryFilled,
                ),
              ],
            ),
          ),
        ),

        // ----- Title Section
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 113,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 38),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: AppWidgetStyles.cardDecoration(
              context,
            ).copyWith(borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tags and ratings column
                Expanded(
                  // <-- make this Column take full width
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween, // align to start
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Tags
                          Wrap(
                            spacing: 4, // horizontal spacing between tags
                            runSpacing:
                                4, // vertical spacing if wrapped to next line
                            children: vm.place.tags
                                .map(
                                  (tag) => AppButton.textOnly(
                                    text: tag,
                                    backgroundVariant:
                                        BackgroundVariant.primaryTrans,
                                    onPressed: () {},
                                    minHeight: 14,
                                    minWidth: 0,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    textStyleVariant: TextStyleVariant.small,
                                  ),
                                )
                                .toList(),
                          ),

                          AppButton.iconTextSmall(
                            icon: CupertinoIcons.star_fill,
                            onPressed: () {},
                            text: " ${vm.place.rating}",
                            textStyleOverride: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                            boxShadow: [],
                            radius: 10,
                            iconSize: 12,
                            minWidth: 60,
                            minHeight: 28,
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 8,
                      ), // spacing between the title and the tags
                      // Title and Location
                      Text(
                        vm.place.name,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 6),

                      // Location
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.location_solid,
                            size: 12,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            vm.place.location,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: ManropeFontWeight.light),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
