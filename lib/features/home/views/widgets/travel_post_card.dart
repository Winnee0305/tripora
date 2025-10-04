import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/home/models/travel_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripora/core/widgets/app_button.dart';

class TravelPostCard extends StatelessWidget {
  final TravelPost post;

  const TravelPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: AppWidgetStyles.cardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with profile avatar
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.asset(
                  post.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(post.authorImageUrl),
                ),
              ),
            ],
          ),

          // Title, location, likes
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.location_solid,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        post.location,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: ManropeFontWeight.light,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: AppButton.iconTextSmall(
                    onPressed: () {},
                    text: "${post.likes}",
                    iconSize: 14,
                    minHeight: 30,
                    minWidth: 60,
                    icon: CupertinoIcons.heart,
                    boxShadow: [],
                    textStyleOverride: Theme.of(context).textTheme.labelMedium
                        ?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: ManropeFontWeight.regular,
                        ),
                    backgroundVariant: BackgroundVariant.primaryTrans,
                  ),
                ),
                // Likes
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Container(
                //       padding: const EdgeInsets.symmetric(
                //         horizontal: 8,
                //         vertical: 4,
                //       ),
                //       decoration: BoxDecoration(
                //         color: Colors.orange.shade50,
                //         borderRadius: BorderRadius.circular(12),
                //       ),

                // child: Row(
                //   children: [
                //     const SizedBox(width: 8),
                //     Icon(
                //       CupertinoIcons.heart,
                //       size: 14,
                //       color: Theme.of(context).colorScheme.primary,
                //     ),
                //     const SizedBox(width: 4),
                //     Text(
                //       "${post.likes}",
                //       style: Theme.of(context).textTheme.labelMedium
                //           ?.copyWith(
                //             color: Theme.of(context).colorScheme.primary,
                //             fontWeight: ManropeFontWeight.regular,
                //           ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
