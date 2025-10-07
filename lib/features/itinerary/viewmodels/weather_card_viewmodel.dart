import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class WeatherCardViewModel extends ChangeNotifier {
  String _condition = "Sunny";
  double _temperature = 29.0;
  String _lastUpdated = "5 min ago";
  // Getters
  String get condition => _condition;
  double get temperature => _temperature;
  String get lastUpdated => _lastUpdated;

  // Mock initialization (could later be replaced with API call)
  WeatherCardViewModel() {
    _loadMockData();
  }

  void _loadMockData() {
    // Simulate fetching mock weather data
    Future.delayed(const Duration(milliseconds: 500), () {
      _condition = "Cloudy";
      _temperature = 27.4;
      _lastUpdated = "5 mins ago";
      notifyListeners();
    });
  }

  // Optional: refresh function (for pull-to-refresh)
  void refreshWeather() {
    _lastUpdated = "Updated just now";
    notifyListeners();
  }

  IconData get getConditionIcon {
    switch (_condition.toLowerCase()) {
      case "sunny":
        return CupertinoIcons.brightness_solid;
      case "cloudy":
        return CupertinoIcons.cloud;
      case "rainy":
        return CupertinoIcons.cloud_drizzle_fill;
      case "stormy":
        return CupertinoIcons.cloud_bolt_fill;
      case "snowy":
        return CupertinoIcons.snow;
      default:
        return Icons.wb_sunny;
    }
  }
}
