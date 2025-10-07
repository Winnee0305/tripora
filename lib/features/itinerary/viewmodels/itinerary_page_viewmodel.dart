import 'package:flutter/material.dart';
import 'package:tripora/core/services/map_service.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';

class ItineraryPageViewModel extends ChangeNotifier {
  final MapService _mapService = MapService();

  final List<Itinerary> _itinerary = [
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
  ];

  List<Itinerary> get itinerary => _itinerary;
  final Map<int, RouteInfo> _routeInfoMap = {};
  Map<int, RouteInfo> get routeInfoMap => _routeInfoMap;

  /// Load route info for all consecutive destinations
  Future<void> loadRouteInfo() async {
    _routeInfoMap.clear();

    for (int i = 0; i < _itinerary.length - 1; i++) {
      final start = _itinerary[i].destination;
      final end = _itinerary[i + 1].destination;

      final route = await _mapService.getRouteInfo(
        startDestination: start,
        endDestination: end,
        travelStyle: _itinerary[i].travelStyle,
      );

      _routeInfoMap[i] = route;
    }

    notifyListeners();
  }

  /// Reorder and auto-recalculate route info
  Future<void> reorderItems(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;

    final item = _itinerary.removeAt(oldIndex);
    _itinerary.insert(newIndex, item);

    notifyListeners();

    // Recalculate route info after reordering
    await loadRouteInfo();
  }
}
