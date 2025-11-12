import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripora/core/reusable_widgets/app_ink_well.dart';
import 'package:tripora/core/services/place_details_service.dart';
import 'package:tripora/features/exploration/viewmodels/search_suggestion_viewmodel.dart';

class SearchSuggestionSection extends StatelessWidget {
  const SearchSuggestionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchSuggestionViewModel>();

    if (viewModel.suggestions.isEmpty) {
      return const SizedBox.shrink(); // nothing to show
    }

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: viewModel.suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = viewModel.suggestions[index];
          return AppInkWell(
            onTap: () async {
              final service = PlaceDetailsService();

              // Fetch main details
              final placeDetails = await service.fetchPlaceDetails(
                suggestion['place_id'],
              );

              if (placeDetails != null) {
                final name = placeDetails['name'];
                final address = placeDetails['formatted_address'];
                final rating = placeDetails['rating'];
                final openingHours =
                    placeDetails['opening_hours']?['weekday_text'];
                final reviews = placeDetails['reviews'];
                final photos = placeDetails['photos'] as List<dynamic>?;

                String? photoUrl;
                if (photos != null && photos.isNotEmpty) {
                  photoUrl = service.getPhotoUrl(photos[0]['photo_reference']);
                }

                final lat = placeDetails['geometry']['location']['lat'];
                final lng = placeDetails['geometry']['location']['lng'];

                // Fetch nearby attractions
                final nearbyAttractions = await service.fetchNearbyAttractions(
                  lat,
                  lng,
                  radius: 2000,
                );

                print('Name: $name, Address: $address, Rating: $rating');
                print('Photo URL: $photoUrl');
                print('Opening Hours: $openingHours');
                print(
                  'Nearby: ${nearbyAttractions.map((e) => e['name']).toList()}',
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.location_solid,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      suggestion['description'] ?? "Unknown",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
