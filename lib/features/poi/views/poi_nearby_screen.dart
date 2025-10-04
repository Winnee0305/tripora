import 'package:flutter/material.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import '../models/attraction.dart';

class PoiNearbyScreen extends StatelessWidget {
  final PoiPageViewmodel vm;
  const PoiNearbyScreen({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Nearby Attractions
        const Text(
          "Nearby Attractions",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vm.nearbyAttractions.length,
            itemBuilder: (context, index) {
              final attraction = vm.nearbyAttractions[index];
              return _buildAttractionCard(attraction);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAttractionCard(Attraction attraction) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              attraction.imageUrl,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  attraction.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  attraction.distance,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
