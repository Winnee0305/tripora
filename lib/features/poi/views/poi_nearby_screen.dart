import 'package:flutter/material.dart';
import 'package:tripora/core/theme/app_widget_styles.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/features/poi/models/nearby_attraction.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import 'package:tripora/core/theme/app_text_style.dart';
import 'package:tripora/features/poi/views/poi_page.dart';

class PoiNearbyScreen extends StatelessWidget {
  final PoiPageViewmodel vm;
  const PoiNearbyScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    print("Nearby Attractions get: ${vm.poi!.nearbyAttractions}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),

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
        const SizedBox(height: 22),
        Container(
          height: 110,
          padding: const EdgeInsets.only(left: 30.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: vm.poi!.nearbyAttractions!.length,
            itemBuilder: (context, index) {
              final attraction = vm.poi!.nearbyAttractions![index];
              return _buildAttractionCard(attraction, context);
            },
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildAttractionCard(
    NearbyAttraction attraction,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigate to POI page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PoiPage(placeId: attraction.poi.id),
          ),
        );
      },
      child: Container(
        height: 110,
        width: 230, // finite width for ListView
        margin: const EdgeInsets.only(right: 20),
        decoration: AppWidgetStyles.cardDecoration(context),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                attraction.poi.imageUrl.isNotEmpty
                    ? attraction.poi.imageUrl
                    : 'https://via.placeholder.com/110',
                height: 110,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 110,
                  width: 110,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return SizedBox(
                    height: 110,
                    width: 110,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      attraction.poi.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                            "${formatDistance(attraction.distanceMeters)} away",
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: ManropeFontWeight.light,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
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
      ),
    );
  }
}
