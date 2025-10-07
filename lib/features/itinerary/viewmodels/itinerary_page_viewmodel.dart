import 'package:flutter/material.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';

class ItineraryPageViewModel extends ChangeNotifier {
  final List<Itinerary> _itinerary = [
    Itinerary(
      destination: "Sunway University",
      tags: ["University", "Education"],
      image: "assets/images/itinerary/sunway_university.png",
      recommendedVisitDuration: "2-3 hrs",
      estimatedCost: "Free",
    ),
    Itinerary(
      destination: "Stadthuys",
      tags: ["Museum", "Historical Site"],
      image: "assets/images/itinerary/stadthuys.png",
      recommendedVisitDuration: "1 hr",
      estimatedCost: "Free",
    ),
    Itinerary(
      destination: "Peranakan Place @ Jonker Street Melaka",
      tags: ["Restaurant", "Local Cuisine"],
      image: "assets/images/itinerary/peranakan_place.png",
      recommendedVisitDuration: "1-2 hrs",
      estimatedCost: "RM20-50",
    ),
    Itinerary(
      destination: "Tan Kim Hock @ Jonker Walk",
      tags: ["Souvenir", "Local Delights"],
      image: "assets/images/itinerary/tan_kim_hock.png",
      recommendedVisitDuration: "20 mins",
      estimatedCost: "RM20-40",
    ),
    Itinerary(
      destination: "Mamee Jonker House",
      tags: ["Attraction", "Family Fun"],
      image: "assets/images/itinerary/mamee.png",
      recommendedVisitDuration: "10 mins",
      estimatedCost: "Free",
    ),
  ];

  List<Itinerary> get itinerary => _itinerary;

  void reorderItems(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    final item = _itinerary.removeAt(oldIndex);
    _itinerary.insert(newIndex, item);
    notifyListeners();
  }
}
