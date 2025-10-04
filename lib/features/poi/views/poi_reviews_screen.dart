import 'package:flutter/material.dart';
import 'package:tripora/core/widgets/app_button.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import '../models/review.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/core/widgets/app_expandable_text.dart';

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
              Text("${vm.reviews.length} Reviews"),
              AppButton(onPressed: () {}, icon: Icons.add, text: "Add Review"),
              Text("${vm.place.rating} / 5"),
            ],
          ),
          const SizedBox(height: 8),
          ...vm.reviews
              .map((review) => _buildReviewTile(review, context))
              .toList(),
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(backgroundImage: NetworkImage(review.userAvatar)),
      title: Text(
        review.userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppExpandableText(
            review.content,
            trimLines: 4,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 4),
          Text(
            "${review.date.toLocal()}".split(' ')[0],
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
      trailing: const Icon(Icons.star, color: Colors.orange),
    );
  }
}
