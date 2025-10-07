import 'package:tripora/core/services/map_service.dart';

class Itinerary {
  final String destination;
  final List<String> tags;
  final String image;
  final String estimatedDuration;
  final String estimatedCost;
  RouteInfo? routeInfo; // Optional route info
  TravelStyle travelStyle;

  Itinerary({
    required this.destination,
    required this.tags,
    required this.image,
    required this.estimatedDuration,
    required this.estimatedCost,
    this.routeInfo,
    this.travelStyle = TravelStyle.driving,
  });
}
