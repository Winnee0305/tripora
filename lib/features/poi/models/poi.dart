import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tripora/core/services/ai_agents_service.dart';
import 'package:tripora/core/utils/constants.dart';
import 'package:tripora/core/utils/format_utils.dart';
import 'package:tripora/core/utils/math_utils.dart';
import 'package:tripora/features/poi/models/nearby_attraction.dart';
import 'operating_hours.dart';
import 'review.dart';
import 'package:tripora/core/services/place_details_service.dart';

class Poi {
  final String id;
  final String name;
  final String country;
  String description;
  final String imageUrl;
  final double rating;
  final int userRatingsTotal;
  final List<OperatingHours> operatingHours;
  final String address;
  final List<Review> reviews;
  List<NearbyAttraction>? nearbyAttractions;
  final double lat;
  final double lng;
  final String phoneNumber;
  final List<String> tags;

  Poi({
    required this.id,
    this.name = '',
    this.country = '',
    this.description = '',
    this.imageUrl = '',
    this.rating = 0.0,
    this.userRatingsTotal = 0,
    this.operatingHours = const [],
    this.address = '',
    this.reviews = const [],
    List<NearbyAttraction>? nearbyAttractions, // nullable parameter
    this.lat = 0.0,
    this.lng = 0.0,
    this.phoneNumber = '',
    this.tags = const [],
  }) : nearbyAttractions = nearbyAttractions ?? []; // initialize here

  static final PlaceDetailsService _service = PlaceDetailsService();

  /// Factory constructor to fetch all details from a placeId
  Future<Poi> fromPlaceId(placeId) async {
    try {
      final data = await _service.fetchPlaceDetails(placeId);

      if (data == null) throw Exception("No data for placeId $placeId");
      final lat = data['geometry']?['location']?['lat'] ?? 0.0;
      final lng = data['geometry']?['location']?['lng'] ?? 0.0;
      final address = data['formatted_address'] ?? '';

      return Poi(
        id: placeId,
        name: data['name'] ?? '',
        country: _parseCountry(address),
        imageUrl: _parsePhoto(data['photos']),
        rating: (data['rating'] ?? 0).toDouble(),
        userRatingsTotal: data['user_ratings_total'] ?? 0,
        operatingHours: _parseOperatingHours(data['opening_hours']),
        address: address,
        reviews: _parseReviews(data['reviews']),
        lat: lat,
        lng: lng,
        phoneNumber: data['international_phone_number'] ?? '',
        tags: _parseTags(data['types']),

        // nearbyAttractions: await _service.fetchNearbyAttractions(lat, lng),
      );
    } catch (e) {
      if (kDebugMode) print("Poi.fromPlaceId error: $e");
      return Poi(id: placeId); // Return empty safe Poi object on error
    }
  }

  static String _parsePhoto(List<dynamic>? photos, {int maxWidth = 800}) {
    if (photos == null || photos.isEmpty) {
      // fallback image if no photos are available
      return '';
    }

    final firstPhoto = photos.first;
    final photoReference = firstPhoto['photo_reference'];
    if (photoReference == null) {
      return '';
    }

    return 'https://maps.googleapis.com/maps/api/place/photo'
        '?maxwidth=$maxWidth'
        '&photoreference=$photoReference'
        '&key=$mapApiKey';
  }

  static String _parseCountry(String address) {
    final parts = address.split(',');
    return parts.isNotEmpty ? parts.last.trim() : '';
  }

  static List<String> _parseTags(List<dynamic>? types) {
    if (types == null) return [];

    return types.map((t) {
      final cleaned = t.toString().replaceAll('_', ' ');
      return cleaned[0].toUpperCase() + cleaned.substring(1);
    }).toList();
  }

  static List<OperatingHours> _parseOperatingHours(
    Map<String, dynamic>? openingHours,
  ) {
    if (openingHours == null || openingHours['periods'] == null) return [];

    final hours = <OperatingHours>[];

    for (var period in openingHours['periods']) {
      final openData = period['open'];
      final closeData = period['close'];

      final dayIndex = openData['day'] ?? 0;
      final day = dayMap[dayIndex] ?? 'Unknown';

      final openTime = formatTime(openData['time'] ?? '0000');
      final closeTime = closeData != null
          ? formatTime(closeData['time'] ?? '2359')
          : 'Open 24 hours';

      hours.add(OperatingHours(day: day, open: openTime, close: closeTime));
      print('Parsed hours for $day: $openTime - $closeTime');
    }

    return hours;
  }

  Future<void> loadDesc() async {
    final aiDesc = await getPoiDesc(name, address);
    description = aiDesc; // updates this POI's description
  }

  static List<Review> _parseReviews(List<dynamic>? reviewsData) {
    if (reviewsData == null) return [];
    return reviewsData.map((r) {
      DateTime parsedDate;
      try {
        parsedDate =
            DateTime.tryParse(r['relative_time_description'] ?? '') ??
            DateTime.now();
      } catch (_) {
        parsedDate = DateTime.now();
      }
      return Review(
        userName: r['author_name'] ?? 'Anonymous',
        userAvatar: r['profile_photo_url'] ?? 'assets/logo/tripora.JPG',
        content: r['text'] ?? '',
        rating: (r['rating'] ?? 0).toDouble(),
        date: parsedDate,
      );
    }).toList();
  }

  Future<void> loadNearbyAttractions() async {
    final placeData = await _service.fetchNearbyAttractions(lat, lng);

    final futures = placeData.map((item) async {
      final placeId = item['place_id'];
      if (placeId == null || placeId.isEmpty) return null;

      try {
        final poi = await fromPlaceId(placeId);
        final distance = calculateDistance(lat, lng, poi.lat, poi.lng) * 1000;
        return NearbyAttraction(poi: poi, distanceMeters: distance);
      } catch (e) {
        print('Failed to fetch POI for $placeId: $e');
        return null;
      }
    }).toList();

    nearbyAttractions = (await Future.wait(
      futures,
    )).whereType<NearbyAttraction>().toList();
  }
}
