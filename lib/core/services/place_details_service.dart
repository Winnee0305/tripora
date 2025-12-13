import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/utils/constants.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class PlaceDetailsService {
  final String apiKey;
  final FirestoreService _firestoreService;

  PlaceDetailsService({
    this.apiKey = mapApiKey,
    FirestoreService? firestoreService,
  }) : _firestoreService = firestoreService ?? FirestoreService();

  Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
    if (placeId.isEmpty) return null;

    // Step 1: Check local cache first
    var details = await _readLocalPlaceDetailsCache(placeId);
    if (details != null) {
      if (kDebugMode)
        print('✅ [LOCAL] Loaded POI details from local cache: $placeId');
      return details;
    }

    // Step 2: Check Firestore cache with expiration logic
    details = await _readPlaceDetailsWithExpiration(placeId);
    if (details != null) {
      if (kDebugMode)
        print('✅ [DATABASE] Loaded POI details from database cache: $placeId');
      // Save to local cache for next time
      await _saveLocalPlaceDetailsCache(placeId, details);
      return details;
    }

    // Step 3: Fetch from Google Places API
    if (kDebugMode) print('🌐 [API] Fetching POI details from API: $placeId');
    final fields =
        'name,geometry,formatted_address,formatted_phone_number,website,rating,opening_hours,photos,reviews,user_ratings_total,international_phone_number,types';
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&fields=$fields';

    try {
      final response = await http.get(Uri.parse(url));
      if (kDebugMode) print("Place Details Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;

          // Cache in both local and database
          await Future.wait([
            _saveLocalPlaceDetailsCache(placeId, result),
            _firestoreService.savePlaceDetails(placeId, result),
          ]);

          if (kDebugMode)
            print(
              '💾 [CACHE] Saved POI details to both local and database: $placeId',
            );
          return result;
        }
      } else {
        throw Exception("Failed to fetch place details");
      }
    } catch (e) {
      if (kDebugMode) print("PlaceDetailsService error: $e");
      return null;
    }

    return null;
  }

  /// Reads place details from local file cache
  Future<Map<String, dynamic>?> _readLocalPlaceDetailsCache(
    String placeId,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/poi_${placeId}.json');

      if (await file.exists()) {
        final raw = jsonDecode(await file.readAsString());

        // Check cache validity (14 days)
        final cachedAtStr = raw['cachedAt'] as String?;
        if (cachedAtStr != null) {
          final cachedAt = DateTime.parse(cachedAtStr);
          final cacheAge = DateTime.now().difference(cachedAt);

          if (cacheAge.inDays >= 14) {
            if (kDebugMode)
              print(
                '⏰ Local cache expired (${cacheAge.inDays} days old) for: $placeId',
              );
            await file.delete(); // Clean up expired cache
            return null;
          }
        }

        return raw['details'] as Map<String, dynamic>?;
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to read local POI cache: $e');
    }
    return null;
  }

  /// Saves place details to local file cache
  Future<void> _saveLocalPlaceDetailsCache(
    String placeId,
    Map<String, dynamic> details,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/poi_${placeId}.json');
      await file.writeAsString(
        jsonEncode({
          'cachedAt': DateTime.now().toIso8601String(),
          'details': details,
        }),
      );
      if (kDebugMode) print('✅ Local POI cache saved: ${file.path}');
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to save local POI cache: $e');
    }
  }

  /// Reads place details from Firestore with cache expiration check (14 days)
  Future<Map<String, dynamic>?> _readPlaceDetailsWithExpiration(
    String placeId,
  ) async {
    final cachedData = await _firestoreService.getPlaceDetails(placeId);

    if (cachedData != null) {
      final details = cachedData['details'] as Map<String, dynamic>?;
      final cachedAt = cachedData['cachedAt'] as Timestamp?;

      // Check if cache is older than 14 days
      if (cachedAt != null) {
        final cacheAge = DateTime.now().difference(cachedAt.toDate());
        if (cacheAge.inDays >= 14) {
          if (kDebugMode)
            print(
              '⏰ Database cache expired (${cacheAge.inDays} days old) for: $placeId',
            );
          return null; // Return null to trigger refetch
        }
      }

      return details;
    }

    return null;
  }

  Future<List<Map<String, String>>> fetchNearbyAttractions(
    double lat,
    double lng, {
    int radius = 1000,
    String type = 'tourist_attraction',
  }) async {
    final cacheFileName =
        'nearby_${lat.toStringAsFixed(5)}_${lng.toStringAsFixed(5)}_${radius}_$type.json';
    final cachedData = await _readNearbyCache(cacheFileName);
    if (cachedData != null) return cachedData;

    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=$type&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] ?? [];

        final limitedResults = results.take(5).toList();
        final simplified = limitedResults.map<Map<String, String>>((item) {
          return {
            'place_id': (item['place_id'] ?? '').toString(),
            'name': (item['name'] ?? '').toString(),
          };
        }).toList();

        // Save to local cache
        await _saveNearbyCache(cacheFileName, simplified);

        return simplified;
      }
    } catch (e) {
      if (kDebugMode) print("Nearby search error: $e");
    }
    return [];
  }

  Future<void> _saveNearbyCache(
    String fileName,
    List<Map<String, String>> data,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(
        jsonEncode({
          'timestamp': DateTime.now().toIso8601String(),
          'results': data,
        }),
      );
      if (kDebugMode) print('✅ Nearby cache saved at: ${file.path}');
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to save nearby cache: $e');
    }
  }

  Future<List<Map<String, String>>?> _readNearbyCache(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      if (await file.exists()) {
        final raw = jsonDecode(await file.readAsString());

        final List<dynamic> resultsDynamic = raw['results'] ?? [];
        final List<Map<String, String>> results = resultsDynamic
            .map<Map<String, String>>((item) {
              return Map<String, String>.from(
                item.map((key, value) => MapEntry(key, value.toString())),
              );
            })
            .toList();

        if (kDebugMode) print('✅ Loaded nearby cache: ${file.path}');
        return results;
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to read nearby cache: $e');
    }
    return null;
  }
}
