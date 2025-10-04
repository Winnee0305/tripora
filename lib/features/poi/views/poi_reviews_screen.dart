import 'package:flutter/material.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import '../models/review.dart';

class PoiReviewsScreen extends StatelessWidget {
  final PoiPageViewmodel vm;
  const PoiReviewsScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Reviews",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("${vm.reviews.length} Reviews"),
          ],
        ),
        const SizedBox(height: 8),
        ...vm.reviews.map((review) => _buildReviewTile(review)).toList(),
        TextButton(onPressed: () {}, child: const Text("See more reviews...")),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildReviewTile(Review review) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(review.userAvatar)),
      title: Text(
        review.userName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(review.content, maxLines: 3, overflow: TextOverflow.ellipsis),
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
