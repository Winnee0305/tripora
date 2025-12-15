import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/core/reusable_widgets/app_loading_network_image.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/poi/models/poi.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';
import 'package:flutter/cupertino.dart';

class DestinationCard extends StatelessWidget {
  final Poi destination;
  final bool isCollected;
  final VoidCallback onHeartPressed;
  final bool isLoading;

  const DestinationCard({
    super.key,
    required this.destination,
    this.isCollected = false,
    required this.onHeartPressed,
    this.isLoading = false,
  });

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
              SizedBox(
                height: 160,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: destination.imageUrl.isNotEmpty
                      ? AppLoadingNetworkImage(imageUrl: destination.imageUrl)
                      : Image.asset(
                          'assets/images/exp_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: isLoading
                    ? SizedBox(
                        width: 40,
                        height: 40,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      )
                    : AppButton.iconOnly(
                        icon: isCollected
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        onPressed: onHeartPressed,
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
                  // Left text block - constrained width to prevent overflow
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // <-- centers text vertically
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          destination.name,
                          style: theme.textTheme.headlineMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                "${extractMalaysiaState(destination.address)}, ${destination.country}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: ManropeFontWeight.light,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

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
