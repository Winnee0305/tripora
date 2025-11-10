import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:tripora/core/utils/constants.dart';

class AutocompleteService {
  final String apiKey;
  final String sessionToken;

  AutocompleteService({
    this.apiKey = MAP_API_KEY,
    this.sessionToken = "1234567890",
  });

  /// Fetch suggestions from Google Places Autocomplete API
  Future<List<dynamic>> fetchSuggestions(String input) async {
    if (input.isEmpty) return [];

    try {
      final String baseUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json";
      final String request =
          "$baseUrl?input=$input&key=$apiKey&sessiontoken=$sessionToken";

      final response = await http.get(Uri.parse(request));

      if (kDebugMode) print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['predictions'] ?? [];
      } else {
        throw Exception("Failed to load suggestions");
      }
    } catch (e) {
      if (kDebugMode) print("AutocompleteService error: $e");
      return [];
    }
  }
}
