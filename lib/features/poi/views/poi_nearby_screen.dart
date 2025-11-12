import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import 'package:tripora/core/theme/app_text_style.dart';

class PoiNearbyScreen extends StatelessWidget {
  final PoiPageViewmodel vm;
  const PoiNearbyScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Nearby Attractions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Text(
            "Nearby Attractions",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: ManropeFontWeight.semiBold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          height: 110,
          padding: const EdgeInsets.only(left: 30.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: vm.poi!.nearbyAttractions.length,
            itemBuilder: (context, index) {
              final attraction = vm.poi!.nearbyAttractions[index];
              return _buildAttractionCard(attraction, context);
            },
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  Widget _buildAttractionCard(dynamic attraction, BuildContext context) {
    return Container(
      height: 110,
      width: 230, // ✅ Finite width (ListView needs this)
      margin: const EdgeInsets.only(right: 20),
      decoration: AppWidgetStyles.cardDecoration(context),
      clipBehavior: Clip.antiAlias, // ensure shadow isn’t cut by content
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              attraction.imageUrl,
              height: 110,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            // ✅ allows text to use remaining space
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    attraction.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: ManropeFontWeight.medium,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Image.asset(
                        "assets/icons/distance.png",
                        height: 12,
                        width: 12,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          "${attraction.distance} km away",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: ManropeFontWeight.light,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ],
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
