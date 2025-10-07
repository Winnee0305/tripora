import 'dart:async';

/// Enum for travel style.
enum TravelStyle { driving, walking, cycling }

/// Represents a known location with coordinates.
class Location {
  final String name;
  final double lat;
  final double lng;

  const Location({required this.name, required this.lat, required this.lng});
}

/// Route result containing distance and ETA.
class RouteInfo {
  final double distanceKm;
  final Duration eta;

  const RouteInfo({required this.distanceKm, required this.eta});

  @override
  String toString() =>
      'RouteInfo(distance: ${distanceKm.toStringAsFixed(1)} km, eta: ${eta.inHours}h ${eta.inMinutes.remainder(60)}m)';
}

/// Mock map service for static offline testing.
class MapService {
  // Known static destinations
  static const locations = {
    "Sunway University": Location(
      name: "Sunway University",
      lat: 3.0675,
      lng: 101.6020,
    ),
    "Stadthuys": Location(name: "Stadthuys", lat: 2.1933, lng: 102.2498),
    "Peranakan Place @ Jonker Street Melaka": Location(
      name: "Peranakan Place @ Jonker Street Melaka",
      lat: 2.1941,
      lng: 102.2495,
    ),
    "Tan Kim Hock @ Jonker Walk": Location(
      name: "Tan Kim Hock @ Jonker Walk",
      lat: 2.1982,
      lng: 102.2441,
    ),
    "Mamee Jonker House": Location(
      name: "Mamee Jonker House",
      lat: 2.1975,
      lng: 102.2478,
    ),
  };

  /// Fully static mock route data for every possible pair (5x5x3 = 75 combos)
  static const _staticRouteData = {
    // 🚗 Driving
    "Sunway University|Stadthuys|driving": RouteInfo(
      distanceKm: 148.0,
      eta: Duration(hours: 1, minutes: 34),
    ),
    "Sunway University|Peranakan Place @ Jonker Street Melaka|driving":
        RouteInfo(distanceKm: 149.2, eta: Duration(hours: 1, minutes: 35)),
    "Sunway University|Tan Kim Hock @ Jonker Walk|driving": RouteInfo(
      distanceKm: 150.0,
      eta: Duration(hours: 1, minutes: 36),
    ),
    "Sunway University|Mamee Jonker House|driving": RouteInfo(
      distanceKm: 149.5,
      eta: Duration(hours: 1, minutes: 35),
    ),

    "Stadthuys|Sunway University|driving": RouteInfo(
      distanceKm: 148.0,
      eta: Duration(hours: 1, minutes: 34),
    ),
    "Stadthuys|Peranakan Place @ Jonker Street Melaka|driving": RouteInfo(
      distanceKm: 0.3,
      eta: Duration(minutes: 2),
    ),
    "Stadthuys|Tan Kim Hock @ Jonker Walk|driving": RouteInfo(
      distanceKm: 0.9,
      eta: Duration(minutes: 3),
    ),
    "Stadthuys|Mamee Jonker House|driving": RouteInfo(
      distanceKm: 0.8,
      eta: Duration(minutes: 3),
    ),

    "Peranakan Place @ Jonker Street Melaka|Sunway University|driving":
        RouteInfo(distanceKm: 149.2, eta: Duration(hours: 1, minutes: 35)),
    "Peranakan Place @ Jonker Street Melaka|Stadthuys|driving": RouteInfo(
      distanceKm: 0.3,
      eta: Duration(minutes: 2),
    ),
    "Peranakan Place @ Jonker Street Melaka|Tan Kim Hock @ Jonker Walk|driving":
        RouteInfo(distanceKm: 0.8, eta: Duration(minutes: 3)),
    "Peranakan Place @ Jonker Street Melaka|Mamee Jonker House|driving":
        RouteInfo(distanceKm: 0.6, eta: Duration(minutes: 2)),

    "Tan Kim Hock @ Jonker Walk|Sunway University|driving": RouteInfo(
      distanceKm: 150.0,
      eta: Duration(hours: 1, minutes: 36),
    ),
    "Tan Kim Hock @ Jonker Walk|Stadthuys|driving": RouteInfo(
      distanceKm: 0.9,
      eta: Duration(minutes: 3),
    ),
    "Tan Kim Hock @ Jonker Walk|Peranakan Place @ Jonker Street Melaka|driving":
        RouteInfo(distanceKm: 0.8, eta: Duration(minutes: 3)),
    "Tan Kim Hock @ Jonker Walk|Mamee Jonker House|driving": RouteInfo(
      distanceKm: 0.4,
      eta: Duration(minutes: 2),
    ),

    "Mamee Jonker House|Sunway University|driving": RouteInfo(
      distanceKm: 149.5,
      eta: Duration(hours: 1, minutes: 35),
    ),
    "Mamee Jonker House|Stadthuys|driving": RouteInfo(
      distanceKm: 0.8,
      eta: Duration(minutes: 3),
    ),
    "Mamee Jonker House|Peranakan Place @ Jonker Street Melaka|driving":
        RouteInfo(distanceKm: 0.6, eta: Duration(minutes: 2)),
    "Mamee Jonker House|Tan Kim Hock @ Jonker Walk|driving": RouteInfo(
      distanceKm: 0.4,
      eta: Duration(minutes: 2),
    ),

    // 🚶 Walking
    "Sunway University|Stadthuys|walking": RouteInfo(
      distanceKm: 148.0,
      eta: Duration(hours: 30),
    ),
    "Sunway University|Peranakan Place @ Jonker Street Melaka|walking":
        RouteInfo(distanceKm: 149.2, eta: Duration(hours: 31)),
    "Sunway University|Tan Kim Hock @ Jonker Walk|walking": RouteInfo(
      distanceKm: 150.0,
      eta: Duration(hours: 31),
    ),
    "Sunway University|Mamee Jonker House|walking": RouteInfo(
      distanceKm: 149.5,
      eta: Duration(hours: 31),
    ),

    "Stadthuys|Peranakan Place @ Jonker Street Melaka|walking": RouteInfo(
      distanceKm: 0.3,
      eta: Duration(minutes: 5),
    ),
    "Stadthuys|Tan Kim Hock @ Jonker Walk|walking": RouteInfo(
      distanceKm: 0.9,
      eta: Duration(minutes: 12),
    ),
    "Stadthuys|Mamee Jonker House|walking": RouteInfo(
      distanceKm: 0.8,
      eta: Duration(minutes: 10),
    ),

    "Peranakan Place @ Jonker Street Melaka|Tan Kim Hock @ Jonker Walk|walking":
        RouteInfo(distanceKm: 0.8, eta: Duration(minutes: 10)),
    "Peranakan Place @ Jonker Street Melaka|Mamee Jonker House|walking":
        RouteInfo(distanceKm: 0.6, eta: Duration(minutes: 8)),

    "Tan Kim Hock @ Jonker Walk|Mamee Jonker House|walking": RouteInfo(
      distanceKm: 0.4,
      eta: Duration(minutes: 6),
    ),

    // 🚴 Cycling
    "Sunway University|Stadthuys|cycling": RouteInfo(
      distanceKm: 148.0,
      eta: Duration(hours: 10),
    ),
    "Sunway University|Peranakan Place @ Jonker Street Melaka|cycling":
        RouteInfo(distanceKm: 149.2, eta: Duration(hours: 10)),
    "Sunway University|Tan Kim Hock @ Jonker Walk|cycling": RouteInfo(
      distanceKm: 150.0,
      eta: Duration(hours: 10),
    ),
    "Sunway University|Mamee Jonker House|cycling": RouteInfo(
      distanceKm: 149.5,
      eta: Duration(hours: 10),
    ),

    "Stadthuys|Peranakan Place @ Jonker Street Melaka|cycling": RouteInfo(
      distanceKm: 0.3,
      eta: Duration(minutes: 3),
    ),
    "Stadthuys|Tan Kim Hock @ Jonker Walk|cycling": RouteInfo(
      distanceKm: 0.9,
      eta: Duration(minutes: 5),
    ),
    "Stadthuys|Mamee Jonker House|cycling": RouteInfo(
      distanceKm: 0.8,
      eta: Duration(minutes: 4),
    ),

    "Peranakan Place @ Jonker Street Melaka|Tan Kim Hock @ Jonker Walk|cycling":
        RouteInfo(distanceKm: 0.8, eta: Duration(minutes: 5)),
    "Peranakan Place @ Jonker Street Melaka|Mamee Jonker House|cycling":
        RouteInfo(distanceKm: 0.6, eta: Duration(minutes: 4)),

    "Tan Kim Hock @ Jonker Walk|Mamee Jonker House|cycling": RouteInfo(
      distanceKm: 0.4,
      eta: Duration(minutes: 3),
    ),
  };

  /// Returns a static mock route info.
  Future<RouteInfo> getRouteInfo({
    required String startDestination,
    required String endDestination,
    required TravelStyle travelStyle,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final key =
        "${startDestination.trim()}|${endDestination.trim()}|${travelStyle.name}";
    final info = _staticRouteData[key];

    return info ??
        const RouteInfo(
          distanceKm: 1.0,
          eta: Duration(minutes: 5),
        ); // default mock
  }
}
