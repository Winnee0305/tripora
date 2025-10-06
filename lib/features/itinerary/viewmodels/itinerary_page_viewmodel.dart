import 'package:flutter/material.dart';
import 'package:tripora/features/itinerary/models/itinerary.dart';

class ItineraryPageViewModel extends ChangeNotifier {
  final List<Itinerary> _itinerary = [
    Itinerary(
      id: 1,
      time: "9:00 am",
      title: "Sunway University",
      subtitle: "1 hr 34 mins · 148 km",
      image: "assets/sunway.jpg",
      distance: "",
      duration: "",
      cost: "",
      category: "",
    ),
    Itinerary(
      id: 2,
      time: "10:43 am",
      title: "Stadthuys",
      subtitle: "Museum · Historical Site",
      image: "assets/stadthuys.jpg",
      distance: "1 hr",
      duration: "",
      cost: "",
      category: "Museum",
    ),
    Itinerary(
      id: 3,
      time: "11:49 am",
      title: "Peranakan Place @ Jonker Street",
      subtitle: "RM20-40 · 1 hr",
      image: "assets/peranakan.jpg",
      distance: "0.5 km",
      duration: "6 mins walk",
      cost: "RM20-40",
      category: "Cultural",
    ),
    Itinerary(
      id: 4,
      time: "12:53 pm",
      title: "Tan Kim Hock @ Jonker Walk",
      subtitle: "RM20-40 · 20 mins",
      image: "assets/tkh.jpg",
      distance: "0.3 km",
      duration: "4 mins walk",
      cost: "RM20-40",
      category: "Souvenir",
    ),
    Itinerary(
      id: 5,
      time: "1:24 pm",
      title: "Mamee Jonker House",
      subtitle: "10 mins walk",
      image: "assets/mamee.jpg",
      distance: "0.6 km",
      duration: "1 min walk",
      cost: "",
      category: "Attraction",
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
