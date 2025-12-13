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
    
    // Check Firestore cache first with expiration logic
    final cachedData = await _readPlaceDetailsWithExpiration(placeId);
    if (cachedData != null) return cachedData;

    final fields =
        'name,geometry,formatted_address,formatted_phone_number,website,rating,opening_hours,photos,reviews,user_ratings_total,international_phone_number,types';
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&fields=$fields';

    try {
      final response = await http.get(Uri.parse(url));
      if (kDebugMode) print("Place Details Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Save to Firestore via service
        if (data['result'] != null) {
          await _firestoreService.savePlaceDetails(placeId, data['result']);
        }

        return data['result'];
      } else {
        throw Exception("Failed to fetch place details");
      }
    } catch (e) {
      if (kDebugMode) print("PlaceDetailsService error: $e");
      return null;
    }
  }

  /// Reads place details from Firestore with cache expiration check (14 days)
  Future<Map<String, dynamic>?> _readPlaceDetailsWithExpiration(String placeId) async {
    final cachedData = await _firestoreService.getPlaceDetails(placeId);
    
    if (cachedData != null) {
      final details = cachedData['details'] as Map<String, dynamic>?;
      final cachedAt = cachedData['cachedAt'] as Timestamp?;
      
      // Check if cache is older than 14 days
      if (cachedAt != null) {
        final cacheAge = DateTime.now().difference(cachedAt.toDate());
        if (cacheAge.inDays >= 14) {
          if (kDebugMode) print('⏰ Place details cache expired (${cacheAge.inDays} days old) for: $placeId');
          return null; // Return null to trigger refetch
        }
      }
      
      if (kDebugMode) print('✅ Loaded place details from cache: $placeId');
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
