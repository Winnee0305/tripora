import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_button.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import '../models/review.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/reusable_widgets/app_expandable_text.dart';
import 'package:flutter/cupertino.dart';

class PoiReviewsScreen extends StatefulWidget {
  final PoiPageViewmodel vm;
  const PoiReviewsScreen({super.key, required this.vm});

  @override
  State<PoiReviewsScreen> createState() => _PoiReviewsScreenState();
}

class _PoiReviewsScreenState extends State<PoiReviewsScreen> {
  int _visibleCount = 2; // start with 2 reviews

  @override
  Widget build(BuildContext context) {
    final reviews = widget.vm.poi!.reviews;
    final displayedReviews = reviews.take(_visibleCount).toList();
    final allVisible = _visibleCount >= reviews.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Reviews",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: ManropeFontWeight.semiBold,
                ),
              ),
              Row(
                children: [
                  AppButton.iconTextSmall(
                    icon: CupertinoIcons.star_fill,
                    text: "${widget.vm.poi!.rating}",
                    textStyleOverride: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: ManropeFontWeight.semiBold),
                    onPressed: () {},
                    iconSize: 14,
                    radius: 10,
                    minHeight: 36,
                    minWidth: 74,
                    backgroundVariant: BackgroundVariant.primaryTrans,
                  ),
                  const SizedBox(width: 14),
                  AppButton.iconTextSmall(
                    icon: CupertinoIcons.ellipses_bubble_fill,
                    text: "${widget.vm.poi!.userRatingsTotal}",
                    textStyleOverride: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontWeight: ManropeFontWeight.semiBold),

                    onPressed: () {},
                    iconSize: 14,
                    radius: 10,
                    minHeight: 34,
                    minWidth: 74,
                    backgroundVariant: BackgroundVariant.primaryTrans,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- Display reviews ---
          ...displayedReviews.map(
            (review) => _buildReviewTile(review, context),
          ),

          // --- See more button ---
          if (reviews.length > 2)
            TextButton(
              onPressed: () {
                setState(() {
                  if (allVisible) {
                    // reset to 2
                    _visibleCount = 2;
                  } else {
                    // show 2 more
                    _visibleCount = (_visibleCount + 2).clamp(
                      0,
                      reviews.length,
                    );
                  }
                });
              },
              child: Text(
                allVisible ? "Show less reviews..." : "Show more reviews...",
              ),
            ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildReviewTile(Review review, BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              review.userAvatar,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.person, size: 50);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.userName,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: ManropeFontWeight.semiBold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < review.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      "${review.date.toLocal()}".split(' ')[0],
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                AppExpandableText(
                  review.content,
                  trimLines: 4,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: ManropeFontWeight.light,
                  ),
                ),
                const SizedBox(height: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
