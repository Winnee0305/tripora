import 'package:flutter/material.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/repositories/ai_agents_repository.dart';
import 'package:tripora/core/repositories/itinerary_repository.dart';
import 'package:tripora/core/services/ai_agents_service.dart';

/// Simple mock RouteInfo model (for testing only)
class RouteInfo {
  final String distance;
  final String duration;
  final ScrollController scrollController = ScrollController();

  RouteInfo({required this.distance, required this.duration});
}

/// ViewModel with mock route data
class ItineraryViewModel extends ChangeNotifier {
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
  bool get isSync => checkIsSync();

  bool checkIsSync() {
    if (itinerariesMap.length != getTotalDays()) return false;

    for (final day in itinerariesMap.keys) {
      final localList = itinerariesMap[day]!;

      // Filter remote list for items on this day
      final remoteList = itineraries
          .where((it) => getDayNumber(it.date, trip!.startDate!) == day)
          .toList();

      if (localList.length != remoteList.length) return false;

      // Sort both lists by sequence so that mapping to mapToList is consistent
      final sortedLocal = List<ItineraryData>.from(localList)
        ..sort((a, b) => a.sequence.compareTo(b.sequence));
      final sortedRemote = List<ItineraryData>.from(remoteList)
        ..sort((a, b) => a.sequence.compareTo(b.sequence));

      for (int i = 0; i < sortedLocal.length; i++) {
        if (!areItinerariesEqual(sortedLocal[i], sortedRemote[i])) return false;
      }
    }

    return true;
  }

  int getTotalDays() {
    return trip!.endDate!.difference(trip!.startDate!).inDays + 1;
  }

  bool areItinerariesEqual(ItineraryData a, ItineraryData b) {
    // return a.id == b.id &&
    return a.placeId == b.placeId &&
        a.userNotes == b.userNotes &&
        a.date == b.date &&
        a.sequence == b.sequence;
  }

  Future<void> initialise() async {
    await loadItineraries();
    listToMap(itineraries, trip!.startDate!, trip!.endDate!);
  }

  Future<void> loadItineraries() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      itineraries = await _itineraryRepo.getItineraries(trip!.tripId);
      print('Itineraries loaded: ${itineraries.length} items');
      for (var itinerary in itineraries) {
        itinerary.loadPlaceDetails();
      }
    } catch (e) {
      _error = 'Failed to load trips: $e';
    }

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

    // 3. Sort each day's items by sequence
    for (final day in dailyMap.keys) {
      dailyMap[day]!.sort((a, b) => a.sequence.compareTo(b.sequence));
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

  void reorderWithinDay(int day, int oldIndex, int newIndex) {
    final dayList = List<ItineraryData>.from(itinerariesMap[day]!);

    if (newIndex > oldIndex) newIndex -= 1;

    final item = dayList.removeAt(oldIndex);
    dayList.insert(newIndex, item);

    // Recompute sequence numbers for all items in the day
    for (int i = 0; i < dayList.length; i++) {
      dayList[i] = dayList[i].copyWith(
        sequence: i,
        lastUpdated: DateTime.now(),
      );
    }

    itinerariesMap = {...itinerariesMap, day: dayList};
    notifyListeners();
  }

  /// Move itinerary item between different days
  void moveItemBetweenDays(
    int fromDay,
    int toDay,
    ItineraryData itinerary,
    int newIndex,
  ) {
    if (fromDay == toDay) return; // already handled by reorderWithinDay

    final fromList = List<ItineraryData>.from(itinerariesMap[fromDay]!);
    final toList = List<ItineraryData>.from(itinerariesMap[toDay]!);

    fromList.remove(itinerary);

    // Make sure newIndex is valid
    final insertIndex = newIndex.clamp(0, toList.length);
    toList.insert(insertIndex, itinerary);

    // Update map immutably to trigger rebuild
    itinerariesMap = {...itinerariesMap, fromDay: fromList, toDay: toList};

    notifyListeners();
  }

  void deleteItinerary(ItineraryData itinerary) {
    itinerariesMap.forEach((day, itemList) {
      itemList.removeWhere((item) => item.id == itinerary.id);
    });
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

  bool validateForm() => destinationController.text.trim().isNotEmpty;

  Future<ItineraryData> getNewItinerary(ItineraryData oldItinerary) async {
    // Copy existing itinerary
    final updatedItinerary = oldItinerary.copyWith(
      placeId: selectedPlaceId ?? oldItinerary.placeId,
      userNotes: notesController.text.trim(),
      lastUpdated: DateTime.now(),
    );

    // Optionally reload place details if placeId changed
    if (updatedItinerary.placeId != oldItinerary.placeId) {
      await updatedItinerary.loadPlaceDetails();
    }

    return updatedItinerary;
  }

  void updateItinerary(ItineraryData oldItinerary) async {
    // Find the day entry that contains the old itinerary
    MapEntry<int, List<ItineraryData>>? dayEntry;

    for (final entry in itinerariesMap.entries) {
      if (entry.value.contains(oldItinerary)) {
        dayEntry = entry;
        break;
      }
    }

    if (dayEntry == null) return; // Not found, nothing to update

    final day = dayEntry.key;
    final index = dayEntry.value.indexOf(oldItinerary);

    if (index == -1) return;

    // Fetch or generate the updated itinerary
    final newItinerary = await getNewItinerary(
      oldItinerary,
    ); // your async update

    // Replace the old itinerary in the map
    final updatedList = List<ItineraryData>.from(dayEntry.value);
    updatedList[index] = newItinerary;
    itinerariesMap[day] = updatedList;

    notifyListeners();
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

  Future<Map<String, dynamic>?> generateAIPlan() async {
    if (trip == null) return null;

    try {
      final aiRepo = AIAgentRepository(service: AIAgentService());

      // Calculate trip duration in days
      final tripDuration =
          trip!.endDate!.difference(trip!.startDate!).inDays + 1;

      // Prepare the request body
      final body = {
        'destination_state': trip!.destination,
        'max_pois_per_day': 6,
        'number_of_travelers': trip!.travelersCount,
        'preferred_poi_names': [],
        'trip_duration_days': tripDuration,
        'user_preferences': [trip!.travelStyle, trip!.travelPartnerType],
      };

      print('=== AI Plan Request ===');
      print('Body: $body');

      final result = await aiRepo.planTripMobile(body);

      print('=== AI Plan Result ===');
      print('Result: $result');

      return result;
    } catch (e) {
      _error = 'Failed to generate AI plan: $e';
      print('Error in generateAIPlan: $e');
      notifyListeners();
      return null;
    }
  }

  Future<void> processAIPlanResult(dynamic result) async {
    if (result == null || trip == null) return;

    try {
      // Expected result format: { "pois_sequence": [...] }
      final poisSequence = result['pois_sequence'] as List<dynamic>?;

      if (poisSequence == null) {
        print('No pois_sequence data in result');
        return;
      }

      print('Processing ${poisSequence.length} POIs from AI result');

      // Group POIs by day
      final Map<int, List<Map<String, dynamic>>> poisByDay = {};

      for (var poi in poisSequence) {
        final poiMap = poi as Map<String, dynamic>;
        final day = poiMap['day'] as int;

        if (!poisByDay.containsKey(day)) {
          poisByDay[day] = [];
        }
        poisByDay[day]!.add(poiMap);
      }

      // Create new itineraries map with all days initialized
      final totalDays = trip!.endDate!.difference(trip!.startDate!).inDays + 1;

      final newItinerariesMap = <int, List<ItineraryData>>{};

      // Initialize all days with empty lists
      for (int i = 1; i <= totalDays; i++) {
        newItinerariesMap[i] = [];
      }

      // Process each day that has POIs
      for (var entry in poisByDay.entries) {
        final dayNumber = entry.key;
        final pois = entry.value;

        final List<ItineraryData> dayItineraries = [];

        // Sort by sequence_number
        pois.sort(
          (a, b) => (a['sequence_number'] as int).compareTo(
            b['sequence_number'] as int,
          ),
        );

        for (int i = 0; i < pois.length; i++) {
          final poi = pois[i];

          // Calculate the date for this day
          final date = trip!.startDate!.add(Duration(days: dayNumber - 1));

          // Create itinerary item
          final itinerary = ItineraryData(
            id: '', // Will be generated when synced
            placeId: poi['google_place_id'] ?? '',
            date: date,
            userNotes: poi['name'] ?? '', // Use POI name as notes
            sequence: i,
            lastUpdated: DateTime.now(),
          );

          // Load place details asynchronously
          await itinerary.loadPlaceDetails();

          dayItineraries.add(itinerary);
        }

        newItinerariesMap[dayNumber] = dayItineraries;
      }

      // Update the itineraries map using the proper method
      listToMap(
        newItinerariesMap.values.expand((list) => list).toList(),
        trip!.startDate!,
        trip!.endDate!,
      );

      print('Successfully processed ${poisByDay.length} days of itinerary');
    } catch (e) {
      _error = 'Error processing AI result: $e';
      print('Error in processAIPlanResult: $e');
      notifyListeners();
      rethrow;
    }
  }

  Future<void> syncItineraries() async {
    if (trip == null) return;

    try {
      print('Starting sync of itineraries...');
      _isUploading = true;
      print("isUploading: $isUploading");
      notifyListeners();
      // <-- artificial delay so the uploading icon is visible
      await Future.delayed(const Duration(seconds: 3));

      final remoteList = itineraries; // The one fetched from DB
      final localList = mapByDayToList(itinerariesMap); // The one user edited

      // Convert to easy lookup maps
      final remoteMap = {for (var it in remoteList) it.id: it};
      final localMap = {for (var it in localList) it.id: it};

      // --- Step 2: detect NEW & UPDATED items ---
      final List<ItineraryData> toCreate = [];
      final List<ItineraryData> toUpdate = [];

      for (final local in localList) {
        if (local.id.isEmpty) {
          // New item (no id yet)
          toCreate.add(local);
        } else if (remoteMap.containsKey(local.id)) {
          final remote = remoteMap[local.id]!;

          // Compare lastUpdated timestamps
          if (local.lastUpdated.isAfter(remote.lastUpdated)) {
            toUpdate.add(local);
          }
        }
      }

      // --- Step 3: detect DELETED items ---
      final List<String> toDelete = [];

      for (final remote in remoteList) {
        if (!localMap.containsKey(remote.id)) {
          toDelete.add(remote.id);
        }
      }

      print("Items to create: ${toCreate.toString()}");
      print("Items to update: ${toUpdate.toString()}");
      print("Items to delete: ${toDelete.toString()}");

      // --- Step 4: push changes to DB ---
      for (final item in toCreate) {
        await _itineraryRepo.createItinerary(item, trip!.tripId);
      }

      for (final item in toUpdate) {
        await _itineraryRepo.updateItinerary(item, trip!.tripId);
      }

      for (final item in toDelete) {
        await _itineraryRepo.deleteItinerary(trip!.tripId, item);
      }

      _isUploading = false;
      await loadItineraries();
      notifyListeners();
    } catch (e) {
      _error = "Sync failed: $e";
      _isUploading = false;
      notifyListeners();
    }
  }
}
