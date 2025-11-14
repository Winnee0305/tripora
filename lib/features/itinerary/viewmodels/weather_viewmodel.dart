import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tripora/features/itinerary/models/weather_for_date.dart';
import 'package:tripora/core/utils/format_utils.dart';

class WeatherViewModel extends ChangeNotifier {
  final List<DateTime> dates;
  final double latitude;
  final double longitude;
  bool _isLoading = false;
  bool _isDisposed = false;

  final List<WeatherForDate> _dailyForecasts = [];

  WeatherViewModel({
    required this.dates,
    required this.latitude,
    required this.longitude,
  });

  bool get isLoading => _isLoading;

  List<WeatherForDate> get dailyForecasts => _dailyForecasts;

  Future<void> fetchForecasts() async {
    _isLoading = true;
    notifyListeners();

    await _initializeForecasts(); // await the async function
    _isLoading = false;
    notifyListeners();
  }

  /// Fetch forecasts from API or fallback
  Future<void> _initializeForecasts() async {
    final apiEnd = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$latitude&longitude=$longitude&daily=temperature_2m_max,weathercode&timezone=auto',
    );

    try {
      final response = await http.get(apiEnd);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final daily = data['daily'];
        final datesFromApi = List<String>.from(daily['time']);
        final temps = List<double>.from(
          daily['temperature_2m_max'].map((t) => (t as num).toDouble()),
        );
        final codes = List<int>.from(daily['weathercode']);

        for (final date in dates) {
          final dateStr = date.toIso8601String().substring(0, 10);
          final index = datesFromApi.indexOf(dateStr);

          if (index != -1) {
            _dailyForecasts.add(
              WeatherForDate(
                date: date,
                temperature: temps[index],
                condition: _weatherCodeToCondition(codes[index]),
                icon: getWeatherConditionIcon(
                  _weatherCodeToCondition(codes[index]),
                ),
              ),
            );
          } else {
            _dailyForecasts.add(
              WeatherForDate(
                date: date,
                temperature: 0.0,
                condition: "Unknown",
                icon: getWeatherConditionIcon("Unknown"),
              ),
            );
          }
        }

        notifyListeners();
      } else {
        _useFallbackForAll();
      }
    } catch (_) {
      _useFallbackForAll();
    }

    if (!_isDisposed) notifyListeners();
  }

  // Convert weather codes to condition
  String _weatherCodeToCondition(int code) {
    print('Mapping weather code: $code');
    switch (code) {
      case 0:
        return "Clear";
      case 1:
      case 2:
        return "Partly Cloudy";
      case 3:
        return "Cloudy";
      case 45:
      case 48:
        return "Fog";
      case 51:
      case 53:
      case 55:
        return "Drizzle";
      case 61:
      case 63:
      case 65:
        return "Rain";
      case 66:
      case 67:
        return "Freezing Rain";
      case 71:
      case 73:
      case 75:
        return "Snow";
      case 77:
        return "Snow Grains";
      case 80:
      case 81:
      case 82:
        return "Rain Showers";
      case 85:
      case 86:
        return "Snow Showers";
      case 95:
      case 96:
      case 99:
        return "Thunderstorm";
      default:
        return "Unknown";
    }
  }

  void _useFallbackForAll() {
    _dailyForecasts.clear();
    for (final date in dates) {
      _dailyForecasts.add(
        WeatherForDate(
          date: date,
          temperature: 0.0,
          condition: "Unknown",
          icon: getWeatherConditionIcon("Unknown"),
        ),
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  WeatherForDate? forecast(int index) {
    if (index < 0 || index >= _dailyForecasts.length) return null;
    return _dailyForecasts[index];
  }
}
