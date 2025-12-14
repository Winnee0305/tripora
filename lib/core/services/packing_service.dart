import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/trip_data.dart';

class PackingService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  Future<Map<String, dynamic>> generatePackingList(
    TripData trip, {
    List<ItineraryData>? itinerary,
  }) async {
    try {
      // Calculate trip duration in days
      int tripDurationDays = 1;
      if (trip.startDate != null && trip.endDate != null) {
        tripDurationDays = trip.endDate!.difference(trip.startDate!).inDays + 1;
      }

      // Format daily itineraries with activities
      final List<Map<String, dynamic>> dailyItineraries = [];
      if (itinerary != null && itinerary.isNotEmpty) {
        for (final day in itinerary) {
          final activities = <Map<String, dynamic>>[];

          // Add place as activity
          if (day.place != null) {
            activities.add({
              'name': day.place!.name,
              'tag': day.place!.tags.isNotEmpty
                  ? day.place!.tags.first
                  : 'general',
            });
          }

          dailyItineraries.add({
            'day': day.date.toIso8601String(),
            'activities': activities,
          });
        }
      }

      final payload = {
        'trip_id': trip.tripId,
        'destination': trip.destination,
        'destination_state': trip.destination, // Use destination as state
        'start_date': trip.startDate?.toIso8601String(),
        'end_date': trip.endDate?.toIso8601String(),
        'trip_duration_days': tripDurationDays,
        'daily_itineraries': dailyItineraries,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/supervisor/generate-packing-list/mobile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      _handleError(response);
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      print('Error generating packing list: $e');
      rethrow;
    }
  }

  void _handleError(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    throw Exception('API Error ${response.statusCode}: ${response.body}');
  }
}
