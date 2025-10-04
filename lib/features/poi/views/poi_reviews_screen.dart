import 'package:flutter/material.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import '../models/review.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_expandable_text.dart';
import 'package:flutter/cupertino.dart';

class PoiReviewsScreen extends StatelessWidget {
  final PoiPageViewmodel vm;
  const PoiReviewsScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
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
                // ----- Rating and Reviews Count
                children: [
                  AppButton.iconTextSmall(
                    icon: CupertinoIcons.star_fill,
                    text: "${vm.place.rating}",
                    onPressed: () {},
                    iconSize: 14,
                    radius: 10,
                    minHeight: 32,
                    minWidth: 64,
                    backgroundVariant: BackgroundVariant.primaryTrans,
                  ),
                  const SizedBox(width: 8),
                  AppButton.iconTextSmall(
                    icon: CupertinoIcons.ellipses_bubble_fill,
                    text: "${vm.reviews.length}",
                    onPressed: () {},
                    iconSize: 14,
                    radius: 10,
                    minHeight: 32,
                    minWidth: 64,
                    backgroundVariant: BackgroundVariant.primaryTrans,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ------ Reviews
          ...vm.reviews.map((review) => _buildReviewTile(review, context)),
          TextButton(
            onPressed: () {},
            child: const Text("See more reviews..."),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildReviewTile(Review review, context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(
              8,
            ), // adjust corner radius as needed
            child: Image.asset(
              review.userAvatar,
              width: 50, // set size same as your CircleAvatar radius * 2
              height: 50,
              fit: BoxFit.cover,
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
                        (index) => const Icon(
                          Icons.star,
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
