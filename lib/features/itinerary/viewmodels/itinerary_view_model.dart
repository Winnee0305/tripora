import 'package:flutter/material.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/repositories/itinerary_repository.dart';

/// Simple mock RouteInfo model (for testing only)
class RouteInfo {
  final String distance;
  final String duration;
  // final Map<int, GlobalKey> dayKeys = {};
  final ScrollController scrollController = ScrollController();

  RouteInfo({required this.distance, required this.duration});
}

/// ViewModel with mock route data
class ItineraryViewModel extends ChangeNotifier {
  // Simple per-day weather and lodging mocks
  // final Map<int, String> _dailyWeather = {1: "Sunny 29°C", 2: "Cloudy 27°C"};
  // final Map<int, String> _dailyLodging = {
  //   1: "AMES Hotel",
  //   2: "Motel Riverside",
  // };
  final ItineraryRepository _itineraryRepo;
  final destinationController = TextEditingController();
  final notesController = TextEditingController();
  String? selectedPlaceId;

  bool isEditingInitialized = false;

  ItineraryViewModel(this._itineraryRepo);

  // --- Local states ---
  List<ItineraryData> itineraries = [];
  Map<int, List<ItineraryData>> itinerariesMap = {};
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;
  TripData? trip;

  // --- Getters ---
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;

  Future<void> loadItineraries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      itineraries = await _itineraryRepo.getItineraries(trip!.tripId);
    } catch (e) {
      _error = 'Failed to load trips: $e';
    }

    listToMap(itineraries, trip!.startDate!, trip!.endDate!);
    _isLoading = false;
    notifyListeners();
  }

  setTrip(TripData tripData) {
    trip = tripData;
  }

  /// Convert flat list of itineraries to a per-day map,
  /// ensuring every day in the trip range exists
  void listToMap(
    List<ItineraryData> itineraries,
    DateTime tripStartDate,
    DateTime tripEndDate,
  ) {
    final Map<int, List<ItineraryData>> dailyMap = {};

    // 1. Initialize all days with empty lists
    final totalDays = tripEndDate.difference(tripStartDate).inDays + 1;
    for (int i = 1; i <= totalDays; i++) {
      dailyMap[i] = [];
    }

    // 2. Assign itineraries to the correct day
    for (final item in itineraries) {
      final day = getDayNumber(item.date, tripStartDate); // Day 1, Day 2, etc.
      if (dailyMap.containsKey(day)) {
        dailyMap[day]!.add(item);
      }
    }

    // 3. Sort each day's items by date/time
    for (final day in dailyMap.keys) {
      dailyMap[day]!.sort((a, b) => a.date.compareTo(b.date));
    }

    itinerariesMap = dailyMap;
    notifyListeners();
  }

  /// Helper: compute day number starting from 1
  int getDayNumber(DateTime itemDate, DateTime tripStartDate) {
    return itemDate.difference(tripStartDate).inDays + 1;
  }

  /// Flatten a per-day map of itineraries back into a list
  List<ItineraryData> mapByDayToList(Map<int, List<ItineraryData>> dailyMap) {
    final List<ItineraryData> flatList = [];

    final sortedDays = dailyMap.keys.toList()..sort();
    for (final day in sortedDays) {
      flatList.addAll(dailyMap[day]!);
    }

    return flatList;
  }

  // final Map<int, List<ItineraryData>> _dailyItineraries = {
  //   1: [
  //     ItineraryData(
  //       destination: "Sunway University",
  //       tags: ["University", "Education"],
  //       image: "assets/images/itinerary/sunway_university.png",
  //       estimatedDuration: "2-3 hrs",
  //       estimatedCost: "Free",
  //       travelStyle: TravelStyle.driving,
  //     ),
  //     Itinerary(
  //       destination: "Stadthuys",
  //       tags: ["Museum", "Historical Site"],
  //       image: "assets/images/itinerary/stadthuys.png",
  //       estimatedDuration: "1 hr",
  //       estimatedCost: "Free",
  //       travelStyle: TravelStyle.driving,
  //     ),
  //     Itinerary(
  //       destination: "Peranakan Place @ Jonker Street Melaka",
  //       tags: ["Restaurant", "Local Cuisine"],
  //       image: "assets/images/itinerary/peranakan_place.png",
  //       estimatedDuration: "1-2 hrs",
  //       estimatedCost: "RM20-50",
  //       travelStyle: TravelStyle.driving,
  //     ),
  //   ],
  //   2: [
  //     Itinerary(
  //       destination: "Tan Kim Hock @ Jonker Walk",
  //       tags: ["Souvenir", "Local Delights"],
  //       image: "assets/images/itinerary/tan_kim_hock.png",
  //       estimatedDuration: "20 mins",
  //       estimatedCost: "RM20-40",
  //       travelStyle: TravelStyle.driving,
  //     ),
  //     Itinerary(
  //       destination: "Mamee Jonker House",
  //       tags: ["Attraction", "Family Fun"],
  //       image: "assets/images/itinerary/mamee.png",
  //       estimatedDuration: "10 mins",
  //       estimatedCost: "Free",
  //       travelStyle: TravelStyle.driving,
  //     ),
  //   ],
  // };

  // Map<int, List<Itinerary>> get dailyItineraries => _dailyItineraries;

  // String? getWeatherForDay(int day) => _dailyWeather[day];
  // String? getLodgingForDay(int day) => _dailyLodging[day];

  // final Map<int, RouteInfo> _routeInfoMap = {};
  // Map<int, RouteInfo> get routeInfoMap => _routeInfoMap;

  // /// Mocked route info loader
  // Future<void> loadAllDayRoutes() async {
  //   _routeInfoMap.clear();

  //   // Just simulate network delay
  //   await Future.delayed(const Duration(milliseconds: 200));

  //   int routeIndex = 0;
  //   for (final entry in _dailyItineraries.entries) {
  //     final items = entry.value;
  //     for (int i = 0; i < items.length - 1; i++) {
  //       // Mocked route data (could randomize)
  //       _routeInfoMap[routeIndex++] = RouteInfo(
  //         distance: "${(i + 1) * 3.2} km",
  //         duration: "${(i + 1) * 12} mins",
  //       );
  //     }
  //   }

  //   notifyListeners();
  // }

  /// Reorder within the same day
  void reorderWithinDay(int day, int oldIndex, int newIndex) {
    final list = itineraries;
    if (newIndex > oldIndex) newIndex -= 1;

    final item = list.removeAt(oldIndex);
    list.insert(newIndex, item);

    notifyListeners();
    // loadAllDayRoutes();
  }

  /// Move itinerary item between different days
  void moveItemBetweenDays(
    int fromDay,
    int toDay,
    ItineraryData itinerary,
    int newIndex,
  ) {
    // itineraries?.remove(itinerary);
    // itineraries[fromDay]?.remove(itinerary);
    // itineraries[toDay]?.insert(newIndex, itinerary);
    notifyListeners();
    // loadAllDayRoutes();
  }

  void clearForm() {
    destinationController.clear();
    notesController.clear();
    isEditingInitialized = false;
    notifyListeners();
  }

  void populateFromItinerary(ItineraryData itinerary) {
    destinationController.text = itinerary.place?.name ?? '';
    notesController.text = itinerary.userNotes;
    isEditingInitialized = true;
    notifyListeners();
  }

  // /// Get formatted date label for each day (e.g. "Mon, 6 Oct")
  // String getDateLabelForDay(int day) {
  //   final startDate = DateTime(2025, 10, 6);
  //   final date = startDate.add(Duration(days: day - 1));
  //   return DateFormat('EEE, d MMM').format(date);
  // }

  bool validateForm() => destinationController.text.trim().isNotEmpty;

  Future<ItineraryData> getNewItinerary(ItineraryData draftItinerary) async {
    print('Creating new itinerary with placeId: ${selectedPlaceId ?? ""}');
    final updatedItinerary = ItineraryData(
      id: "",
      placeId: selectedPlaceId ?? "",
      userNotes: notesController.text.trim(),
      date: draftItinerary.date,
      sequence: draftItinerary.sequence,
      lastUpdated: DateTime.now(),
    );
    await updatedItinerary.loadPlaceDetails();
    return updatedItinerary;
  }

  void updateItinerary(ItineraryData oldItinerary) async {
    final index = itineraries.indexOf(oldItinerary);
    if (index != -1) {
      itineraries[index] = await getNewItinerary(oldItinerary); // TODO
      notifyListeners();
    }
  }

  void addItinerary(ItineraryData draftItinerary) async {
    final newItinerary = await getNewItinerary(draftItinerary);
    addToMap(newItinerary);
    notifyListeners();
  }

  DateTime getDate(int day) {
    final startDate = trip!.startDate!;
    return startDate.add(Duration(days: day - 1));
  }

  int getLastSequence(int day) {
    int count = itinerariesMap[day]?.length ?? 0;
    return count;
  }

  void addToMap(ItineraryData itinerary) {
    final day = getDayNumber(itinerary.date, trip!.startDate!);

    // Create a new list for this day
    final updatedDayList = List<ItineraryData>.from(itinerariesMap[day]!);
    updatedDayList.add(itinerary);

    // Replace the map with a new map including the updated list
    itinerariesMap = {...itinerariesMap, day: updatedDayList};

    notifyListeners(); // now the UI will rebuild
  }
}
