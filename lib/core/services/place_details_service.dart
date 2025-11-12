import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:tripora/core/utils/constants.dart';

class PlaceDetailsService {
  final String apiKey;

  PlaceDetailsService({this.apiKey = mapApiKey});

  Future<Map<String, dynamic>?> fetchPlaceDetails(String placeId) async {
    if (placeId.isEmpty) return null;

    final fields =
        'name,geometry,formatted_address,formatted_phone_number,website,rating,opening_hours,photos,reviews,user_ratings_total,international_phone_number,types';
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey&fields=$fields';

    try {
      final response = await http.get(Uri.parse(url));
      if (kDebugMode) print("Place Details Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // ✅ Save entire raw data for testing
        if (!kIsWeb) {
          await _saveRawPlaceJson(placeId, data);
        } else {
          if (kDebugMode) print('Skipping file save (web build).');
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

  /// Saves the raw JSON from Google to a writable app directory.
  Future<void> _saveRawPlaceJson(
    String placeId,
    Map<String, dynamic> data,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/raw_place_$placeId.json');
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(data),
      );
      if (kDebugMode) print('✅ Raw place JSON saved at: ${file.path}');
    } catch (e) {
      if (kDebugMode) print('⚠️ Failed to save place JSON: $e');
    }
  }

  /// Helper to get photo URL
  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$maxWidth&photoreference=$photoReference&key=$apiKey';
  }

  Future<List<Map<String, String>>> fetchNearbyAttractions(
    double lat,
    double lng, {
    int radius = 1000,
    String type = 'tourist_attraction',
  }) async {
    final url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=$type&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] ?? [];

        // Take only the first 5 results (or fewer if not enough)
        final limitedResults = results.take(5).toList();

        // Extract only the required fields
        final simplified = limitedResults.map<Map<String, String>>((item) {
          return {
            'place_id': (item['place_id'] ?? '').toString(),
            'name': (item['name'] ?? '').toString(),
          };
        }).toList();

        if (kDebugMode) {
          print('Fetched ${simplified.length} nearby attractions');

          // Save JSON for debugging
          final debugJson = jsonEncode({
            'timestamp': DateTime.now().toIso8601String(),
            'count': simplified.length,
            'results': simplified,
          });

          try {
            final dir = await getApplicationDocumentsDirectory();
            final file = File('${dir.path}/nearby_places_debug.json');
            await file.writeAsString(debugJson, mode: FileMode.write);
            print('✅ Debug JSON saved at: ${file.path}');
          } catch (e) {
            print('⚠️ Failed to save debug JSON: $e');
          }
        }

        return simplified;
      }
    } catch (e) {
      if (kDebugMode) print("Nearby search error: $e");
    }
    return [];
  }
}
