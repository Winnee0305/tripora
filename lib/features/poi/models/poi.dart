import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'operating_hours.dart';
import 'review.dart';
import 'package:tripora/core/services/place_details_service.dart';

class Poi {
  final String id;
  final String name;
  final String location;
  final String description;
  final String image;
  final double rating;
  final List<OperatingHours> operatingHours;
  final String address;
  final List<String> tags;
  final List<Review> reviews;
  final List<dynamic> nearbyAttractions;

  const Poi({
    required this.id,
    this.name = '',
    this.location = '',
    this.description = '',
    this.image = 'assets/images/placeholder.png',
    this.rating = 0.0,
    this.operatingHours = const [],
    this.address = '',
    this.tags = const [],
    this.reviews = const [],
    this.nearbyAttractions = const [],
  });

  static final PlaceDetailsService _service = PlaceDetailsService();

  /// Factory constructor to fetch all details from a placeId
  static Future<Poi> fromPlaceId(String placeId) async {
    try {
      final data = await _service.fetchPlaceDetails(placeId);
      // Store the raw API response to a local JSON file for testing
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/place_$placeId.json');

        await file.writeAsString(jsonEncode(data));
        if (kDebugMode) {
          print('✅ Saved place details JSON to: ${file.path}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Failed to save place details JSON: $e');
        }
      }

      if (data == null) throw Exception("No data for placeId $placeId");

      final lat = data['geometry']['location']['lat'];
      final lng = data['geometry']['location']['lng'];

      return Poi(
        id: placeId,
        name: data['name'] ?? '',
        location: data['address'] ?? '',
        description: data['description'] ?? '',
        image: data['photoUrl'] ?? 'assets/images/placeholder.png',
        rating: (data['rating'] ?? 0).toDouble(),
        operatingHours: _parseOperatingHours(data['opening_hours']),
        address: data['address'] ?? '',
        tags: List<String>.from(data['types'] ?? []),
        reviews: _parseReviews(data['reviews']),
        nearbyAttractions: await _service.fetchNearbyAttractions(lat, lng),
      );
    } catch (e) {
      if (kDebugMode) print("Poi.fromPlaceId error: $e");
      return Poi(id: placeId);
    }
  }

  static List<OperatingHours> _parseOperatingHours(
    Map<String, dynamic>? openingHours,
  ) {
    if (openingHours == null || openingHours['weekday_text'] == null) return [];
    return (openingHours['weekday_text'] as List<dynamic>)
        .map((e) {
          final parts = e.toString().split(': ');
          if (parts.length != 2) return null;
          return OperatingHours(
            day: parts[0],
            open: parts[1].split(' – ')[0],
            close: parts[1].split(' – ')[1],
          );
        })
        .whereType<OperatingHours>()
        .toList();
  }

  static List<Review> _parseReviews(List<dynamic>? reviewsData) {
    if (reviewsData == null) return [];
    return reviewsData.map((r) {
      return Review(
        userName: r['author_name'] ?? 'Anonymous',
        userAvatar:
            r['profile_photo_url'] ?? 'assets/images/placeholder_avatar.png',
        content: r['text'] ?? '',
        rating: (r['rating'] ?? 0).toDouble(),
        date:
            DateTime.tryParse(r['relative_time_description'] ?? '') ??
            DateTime.now(),
      );
    }).toList();
  }
}
