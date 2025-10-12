import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';

class DiscoverRecommendationSection extends StatelessWidget {
  const DiscoverRecommendationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "Get Recommendations",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: const [
                _RecommendationChip(
                  image: AssetImage("assets/icons/restaurant.png"),
                  label: "Restaurant",
                ),
                SizedBox(width: 12),
                _RecommendationChip(
                  image: AssetImage("assets/icons/museum.png"),
                  label: "Museum",
                ),
                SizedBox(width: 12),
                _RecommendationChip(
                  image: AssetImage("assets/icons/city.png"),
                  label: "City",
                ),
                SizedBox(width: 12),
                _RecommendationChip(
                  image: AssetImage("assets/icons/nature.png"),
                  label: "Nature",
                ),
                SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _RecommendationChip extends StatelessWidget {
  final AssetImage image;
  final String label;

  const _RecommendationChip({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppWidgetStyles.cardDecoration(
        context,
      ).copyWith(borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Image.asset(image.assetName, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
