import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/features/home/models/destination.dart';
import 'package:tripora/core/theme/app_shadow_theme.dart';
import 'package:flutter/cupertino.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    // The entire card
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        boxShadow:
            Theme.of(context).extension<ShadowTheme>()?.buttonShadows ?? [],
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Image.asset(
              destination.imagePath,
              height: 280,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      destination.location,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: ManropeFontWeight.light,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppButton.iconOnly(
                      icon: CupertinoIcons.heart,
                      onPressed: () {},
                      backgroundVariant: BackgroundVariant.primaryTrans,
                    ),
                    AppButton.iconTextSmall(
                      onPressed: () {},
                      text: "5.0",
                      iconSize: 14,
                      minHeight: 40,
                      minWidth: 70,
                      radius: 10,
                      textStyleOverride: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(
                            fontWeight: ManropeFontWeight.regular,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                      icon: CupertinoIcons.star_fill,
                      boxShadow: [],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
