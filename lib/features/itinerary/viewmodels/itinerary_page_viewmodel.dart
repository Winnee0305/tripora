import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripora/core/services/map_service.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';

/// Simple mock RouteInfo model (for testing only)
class RouteInfo {
  final String distance;
  final String duration;
  final Map<int, GlobalKey> dayKeys = {};
  final ScrollController scrollController = ScrollController();

  RouteInfo({required this.distance, required this.duration});
}

/// ViewModel with mock route data
class ItineraryPageViewModel extends ChangeNotifier {
  // Simple per-day weather and lodging mocks
  final Map<int, String> _dailyWeather = {1: "Sunny 29°C", 2: "Cloudy 27°C"};
  final Map<int, String> _dailyLodging = {
    1: "AMES Hotel",
    2: "Motel Riverside",
  };

  final Map<int, List<Itinerary>> _dailyItineraries = {
    1: [
      Itinerary(
        destination: "Sunway University",
        tags: ["University", "Education"],
        image: "assets/images/itinerary/sunway_university.png",
        estimatedDuration: "2-3 hrs",
        estimatedCost: "Free",
        travelStyle: TravelStyle.driving,
      ),
      Itinerary(
        destination: "Stadthuys",
        tags: ["Museum", "Historical Site"],
        image: "assets/images/itinerary/stadthuys.png",
        estimatedDuration: "1 hr",
        estimatedCost: "Free",
        travelStyle: TravelStyle.driving,
      ),
      Itinerary(
        destination: "Peranakan Place @ Jonker Street Melaka",
        tags: ["Restaurant", "Local Cuisine"],
        image: "assets/images/itinerary/peranakan_place.png",
        estimatedDuration: "1-2 hrs",
        estimatedCost: "RM20-50",
        travelStyle: TravelStyle.driving,
      ),
    ],
    2: [
      Itinerary(
        destination: "Tan Kim Hock @ Jonker Walk",
        tags: ["Souvenir", "Local Delights"],
        image: "assets/images/itinerary/tan_kim_hock.png",
        estimatedDuration: "20 mins",
        estimatedCost: "RM20-40",
        travelStyle: TravelStyle.driving,
      ),
      Itinerary(
        destination: "Mamee Jonker House",
        tags: ["Attraction", "Family Fun"],
        image: "assets/images/itinerary/mamee.png",
        estimatedDuration: "10 mins",
        estimatedCost: "Free",
        travelStyle: TravelStyle.driving,
      ),
    ],
  };

  Map<int, List<Itinerary>> get dailyItineraries => _dailyItineraries;

  String? getWeatherForDay(int day) => _dailyWeather[day];
  String? getLodgingForDay(int day) => _dailyLodging[day];

  final Map<int, RouteInfo> _routeInfoMap = {};
  Map<int, RouteInfo> get routeInfoMap => _routeInfoMap;

  /// Mocked route info loader
  Future<void> loadAllDayRoutes() async {
    _routeInfoMap.clear();

    // Just simulate network delay
    await Future.delayed(const Duration(milliseconds: 200));

    int routeIndex = 0;
    for (final entry in _dailyItineraries.entries) {
      final items = entry.value;
      for (int i = 0; i < items.length - 1; i++) {
        // Mocked route data (could randomize)
        _routeInfoMap[routeIndex++] = RouteInfo(
          distance: "${(i + 1) * 3.2} km",
          duration: "${(i + 1) * 12} mins",
        );
      }
    }

    notifyListeners();
  }

  /// Reorder within the same day
  void reorderWithinDay(int day, int oldIndex, int newIndex) {
    final list = _dailyItineraries[day]!;
    if (newIndex > oldIndex) newIndex -= 1;

    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    notifyListeners();
    loadAllDayRoutes();
  }

  /// Move itinerary item between different days
  void moveItemBetweenDays(
    int fromDay,
    int toDay,
    Itinerary item,
    int newIndex,
  ) {
    _dailyItineraries[fromDay]?.remove(item);
    _dailyItineraries[toDay]?.insert(newIndex, item);
    notifyListeners();
    loadAllDayRoutes();
  }

  /// Get formatted date label for each day (e.g. "Mon, 6 Oct")
  String getDateLabelForDay(int day) {
    final startDate = DateTime(2025, 10, 6);
    final date = startDate.add(Duration(days: day - 1));
    return DateFormat('EEE, d MMM').format(date);
  }
}
