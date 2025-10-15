import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/home/models/destination.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';
import 'package:flutter/cupertino.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: theme.extension<ShadowTheme>()?.buttonShadows ?? [],
      ),
      child: Column(
        children: [
          // ---------- Image Section ----------
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  destination.imagePath,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: AppButton.iconOnly(
                  icon: CupertinoIcons.heart,
                  onPressed: () {},
                  backgroundVariant: BackgroundVariant.secondaryTrans,
                ),
              ),
            ],
          ),

          // ---------- Info Section (centered) ----------
          SizedBox(
            height: 68, // fixed height for balanced layout
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment:
                    CrossAxisAlignment.center, // <-- centers vertically
                children: [
                  // Left text block
                  Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // <-- centers text vertically
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destination.name,
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 12,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            destination.location,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: ManropeFontWeight.light,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Rating button
                  AppButton.iconTextSmall(
                    onPressed: () {},
                    text: destination.rating.toStringAsFixed(1),
                    iconSize: 14,
                    minHeight: 30,
                    minWidth: 60,
                    radius: 30,
                    textStyleOverride: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: ManropeFontWeight.regular,
                      color: theme.colorScheme.onPrimary,
                    ),
                    icon: CupertinoIcons.star_fill,
                    boxShadow: [],
                    backgroundVariant: BackgroundVariant.primaryTrans,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
