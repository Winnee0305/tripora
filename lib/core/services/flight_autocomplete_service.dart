import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Flight Autocomplete Service using AviationStack API
///
/// TROUBLESHOOTING "invalid_access_key" ERROR:
/// 1. Verify your email with AviationStack (check spam folder)
/// 2. Log in to https://aviationstack.com/dashboard
/// 3. Check if your API key is correct (copy from dashboard)
/// 4. Ensure you haven't exceeded free tier limit (100 requests/month)
/// 5. Try regenerating your API key in the dashboard
/// 6. If all else fails, set _useMockData = true for testing
///
/// FREE TIER LIMITATIONS:
/// - 100 API requests per month
/// - HTTP only (no HTTPS)
/// - 1 month historical data
/// - Hourly data updates
class FlightAutocompleteService {
  // Get your API key from https://aviationstack.com/
  // To get a FREE API key:
  // 1. Sign up at https://aviationstack.com/signup/free
  // 2. Verify your email
  // 3. Copy your API key from the dashboard
  // 4. Replace the value below
  //
  // IMPORTANT: If the API key shows an "invalid_access_key" error:
  // - Make sure you've verified your email
  // - Check if your free tier quota (100 requests/month) is exceeded
  // - Try regenerating the API key in your dashboard
  // - Ensure you're using the correct key (not the secret key)
  static const String _apiKey = 'db27b9e31095c6a9a849b6ce5614e9ea';
  static const String _baseUrl = 'http://api.aviationstack.com/v1';

  // Set to true to use mock data for testing without API calls
  static const bool _useMockData = false;

  /// Check if API key is configured
  bool get isApiKeyConfigured =>
      _apiKey.isNotEmpty && !_apiKey.startsWith('YOUR_');

  /// Search for flights by flight number
  /// Returns flight details including airline, departure and arrival airports
  Future<List<Map<String, dynamic>>> searchFlightByNumber(
    String flightNumber,
  ) async {
    if (flightNumber.isEmpty) return [];

    // Use mock data if enabled (for testing without API)
    if (_useMockData) {
      return _getMockFlightData(flightNumber);
    }

    try {
      final String endpoint = '$_baseUrl/flights';
      final Uri uri = Uri.parse(endpoint).replace(
        queryParameters: {
          'access_key': _apiKey,
          'flight_iata': flightNumber.toUpperCase(),
        },
      );

      if (kDebugMode) {
        print('Fetching flight data for: $flightNumber');
        print('Request URL: $uri');
      }

      final response = await http.get(uri);

      if (kDebugMode) {
        print('AviationStack Response Status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Check for API errors in response
        if (data['error'] != null) {
          final error = data['error'];
          if (kDebugMode) {
            print(
              'AviationStack API Error: ${error['code']} - ${error['message']}',
            );
          }
          throw Exception('API Error: ${error['message']}');
        }

        if (data['data'] != null && data['data'] is List) {
          final flights = data['data'] as List;

          if (flights.isEmpty) {
            if (kDebugMode) {
              print('No flights found for: $flightNumber');
            }
            return [];
          }

          if (kDebugMode) {
            print('Found ${flights.length} flight(s) for: $flightNumber');
          }

          return flights.map((flight) {
            final flightData = flight['flight'] as Map<String, dynamic>? ?? {};
            final airline = flight['airline'] as Map<String, dynamic>? ?? {};
            final departure =
                flight['departure'] as Map<String, dynamic>? ?? {};
            final arrival = flight['arrival'] as Map<String, dynamic>? ?? {};

            return {
              'flightNumber': flightData['iata'] ?? flightNumber,
              'airline': airline['name'] ?? '',
              'airlineIata': airline['iata'] ?? '',
              'departureAirport': departure['airport'] ?? '',
              'departureIata': departure['iata'] ?? '',
              'departureTimezone': departure['timezone'] ?? '',
              'departureScheduled': departure['scheduled'] ?? '',
              'arrivalAirport': arrival['airport'] ?? '',
              'arrivalIata': arrival['iata'] ?? '',
              'arrivalTimezone': arrival['timezone'] ?? '',
              'arrivalScheduled': arrival['scheduled'] ?? '',
              'flightStatus': flight['flight_status'] ?? '',
            };
          }).toList();
        } else {
          if (kDebugMode) {
            print('No data field in response or data is not a list');
          }
        }
      } else {
        if (kDebugMode) {
          print('AviationStack API Error: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('FlightAutocompleteService error: $e');
      }
    }

    return [];
  }

  /// Get airline information by IATA code
  Future<Map<String, dynamic>?> getAirlineInfo(String iataCode) async {
    if (iataCode.isEmpty) return null;

    try {
      final String endpoint = '$_baseUrl/airlines';
      final Uri uri = Uri.parse(endpoint).replace(
        queryParameters: {
          'access_key': _apiKey,
          'iata_code': iataCode.toUpperCase(),
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null &&
            data['data'] is List &&
            (data['data'] as List).isNotEmpty) {
          final airline = data['data'][0];
          return {
            'name': airline['airline_name'] ?? '',
            'iata': airline['iata_code'] ?? '',
            'icao': airline['icao_code'] ?? '',
            'country': airline['country_name'] ?? '',
          };
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching airline info: $e');
      }
    }

    return null;
  }

  /// Search airports by query
  Future<List<Map<String, dynamic>>> searchAirports(String query) async {
    if (query.isEmpty) return [];

    try {
      final String endpoint = '$_baseUrl/airports';
      final Uri uri = Uri.parse(
        endpoint,
      ).replace(queryParameters: {'access_key': _apiKey, 'search': query});

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['data'] != null && data['data'] is List) {
          final airports = data['data'] as List;

          return airports.map((airport) {
            return {
              'name': airport['airport_name'] ?? '',
              'iata': airport['iata_code'] ?? '',
              'icao': airport['icao_code'] ?? '',
              'city': airport['city_name'] ?? '',
              'country': airport['country_name'] ?? '',
            };
          }).toList();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error searching airports: $e');
      }
    }

    return [];
  }

  /// Mock flight data for testing without API calls
  List<Map<String, dynamic>> _getMockFlightData(String flightNumber) {
    // Sample mock data for common flight numbers
    final mockFlights = {
      'AA100': {
        'flightNumber': 'AA100',
        'airline': 'American Airlines',
        'airlineIata': 'AA',
        'departureAirport': 'John F Kennedy International',
        'departureIata': 'JFK',
        'departureTimezone': 'America/New_York',
        'departureScheduled': DateTime.now()
            .add(const Duration(hours: 2))
            .toIso8601String(),
        'arrivalAirport': 'Los Angeles International',
        'arrivalIata': 'LAX',
        'arrivalTimezone': 'America/Los_Angeles',
        'arrivalScheduled': DateTime.now()
            .add(const Duration(hours: 8))
            .toIso8601String(),
        'flightStatus': 'scheduled',
      },
      'BA123': {
        'flightNumber': 'BA123',
        'airline': 'British Airways',
        'airlineIata': 'BA',
        'departureAirport': 'London Heathrow',
        'departureIata': 'LHR',
        'departureTimezone': 'Europe/London',
        'departureScheduled': DateTime.now()
            .add(const Duration(hours: 3))
            .toIso8601String(),
        'arrivalAirport': 'John F Kennedy International',
        'arrivalIata': 'JFK',
        'arrivalTimezone': 'America/New_York',
        'arrivalScheduled': DateTime.now()
            .add(const Duration(hours: 10))
            .toIso8601String(),
        'flightStatus': 'scheduled',
      },
    };

    final upperFlightNumber = flightNumber.toUpperCase();
    if (mockFlights.containsKey(upperFlightNumber)) {
      return [mockFlights[upperFlightNumber]!];
    }

    // Return generic mock if flight not found
    return [
      {
        'flightNumber': upperFlightNumber,
        'airline': 'Sample Airlines',
        'airlineIata': upperFlightNumber.substring(0, 2),
        'departureAirport': 'Sample Departure Airport',
        'departureIata': 'DEP',
        'departureTimezone': 'UTC',
        'departureScheduled': DateTime.now()
            .add(const Duration(hours: 2))
            .toIso8601String(),
        'arrivalAirport': 'Sample Arrival Airport',
        'arrivalIata': 'ARR',
        'arrivalTimezone': 'UTC',
        'arrivalScheduled': DateTime.now()
            .add(const Duration(hours: 6))
            .toIso8601String(),
        'flightStatus': 'scheduled',
      },
    ];
  }
}
