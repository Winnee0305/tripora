import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/lodging_data.dart';
import 'package:tripora/core/models/flight_data.dart';
import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/repositories/ai_agents_repository.dart';
import 'package:tripora/core/repositories/itinerary_repository.dart';
import 'package:tripora/core/repositories/lodging_repository.dart';
import 'package:tripora/core/repositories/flight_repository.dart';
import 'package:tripora/core/repositories/post_repository.dart';
import 'package:tripora/core/services/ai_agents_service.dart';
import 'package:tripora/core/services/place_details_service.dart';

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
  final LodgingRepository _lodgingRepo;
  final FlightRepository _flightRepo;
  final PostRepository _postRepo;
  final destinationController = TextEditingController();
  final notesController = TextEditingController();
  String? selectedPlaceId;

  bool isEditingInitialized = false;

  ItineraryViewModel(
    this._itineraryRepo,
    this._lodgingRepo,
    this._flightRepo,
    this._postRepo,
  );

  @override
  void dispose() {
    destinationController.dispose();
    notesController.dispose();
    super.dispose();
  }

  // --- Local states ---
  List<ItineraryData> itineraries = [];
  Map<int, List<ItineraryData>> itinerariesMap = {};
  List<LodgingData> lodgings = [];
  Map<int, List<LodgingData>> lodgingsMap = {};
  List<FlightData> flights = [];
  Map<int, List<FlightData>> flightsMap = {};
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
    await loadLodgings();
    await loadFlights();
    listToMap(itineraries, trip!.startDate!, trip!.endDate!);
    mapLodgingsByDay();
    mapFlightsByDay();
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
    DateTime tripEndDate, {
    bool notify = true,
  }) {
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
    if (notify) {
      notifyListeners();
    }
  }

  /// Helper: compute day number starting from 1
  int getDayNumber(DateTime itemDate, DateTime tripStartDate) {
    final day = itemDate.difference(tripStartDate).inDays + 1;
    return day.clamp(1, getTotalDays());
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
    notifyListeners();
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

  bool validateForm({bool isNote = false}) {
    if (isNote) {
      return notesController.text.trim().isNotEmpty;
    }
    return destinationController.text.trim().isNotEmpty;
  }

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

  List<LatLng> getItineraryLatLngs() {
    final List<LatLng> latLngs = [];

    for (final dayItineraries in itinerariesMap.values) {
      for (final itinerary in dayItineraries) {
        if (itinerary.place != null) {
          latLngs.add(LatLng(itinerary.place!.lat, itinerary.place!.lng));
        }
      }
    }

    return latLngs;
  }

  void updateItinerary(ItineraryData updatedItinerary) async {
    // Find the day entry that contains the itinerary with matching ID
    MapEntry<int, List<ItineraryData>>? dayEntry;
    int? foundIndex;

    for (final entry in itinerariesMap.entries) {
      foundIndex = entry.value.indexWhere(
        (item) => item.id == updatedItinerary.id,
      );
      if (foundIndex != -1) {
        dayEntry = entry;
        break;
      }
    }

    if (dayEntry == null || foundIndex == null || foundIndex == -1) {
      return; // Not found, nothing to update
    }

    final day = dayEntry.key;
    final oldItinerary = dayEntry.value[foundIndex];

    // For notes, use the updated one directly; for destinations, process through getNewItinerary
    final newItinerary = updatedItinerary.isNote
        ? updatedItinerary
        : await getNewItinerary(oldItinerary);

    // Replace the old itinerary in the map
    final updatedList = List<ItineraryData>.from(dayEntry.value);
    updatedList[foundIndex] = newItinerary;
    itinerariesMap[day] = updatedList;

    // Save to Firestore
    await _itineraryRepo.updateItinerary(newItinerary, trip!.tripId);

    notifyListeners();
  }

  void addItinerary(ItineraryData draftItinerary) async {
    // For notes, use the draft directly since it already has the updated userNotes
    // For destinations, process through getNewItinerary to load place details
    final newItinerary = draftItinerary.isNote
        ? draftItinerary
        : await getNewItinerary(draftItinerary);
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

  /// Extract POI names from current itinerary map
  List<String> getPreferredPoiNames() {
    final List<String> poiNames = [];

    for (final dayItineraries in itinerariesMap.values) {
      for (final itinerary in dayItineraries) {
        // Only include destination type items, skip notes
        if (!itinerary.isNote && itinerary.place != null) {
          final poiName = itinerary.place!.name;
          if (poiName.isNotEmpty && !poiNames.contains(poiName)) {
            poiNames.add(poiName);
          }
        }
      }
    }

    return poiNames;
  }

  /// Generate AI plan and automatically process it
  Future<bool> generateAndApplyAIPlan() async {
    if (trip == null) return false;

    try {
      _error = null;

      final aiRepo = AIAgentRepository(service: AIAgentService());

      // Calculate trip duration in days
      final tripDuration =
          trip!.endDate!.difference(trip!.startDate!).inDays + 1;

      // Get preferred POI names from current itinerary
      final preferredPoiNames = getPreferredPoiNames();

      // Prepare the request body
      final body = {
        'destination_state': trip!.destination,
        'max_pois_per_day': 10,
        'number_of_travelers': trip!.travelersCount,
        'preferred_poi_names': preferredPoiNames,
        'trip_duration_days': tripDuration,
        'user_preferences': [trip!.travelStyle, trip!.travelPartnerType],
      };

      print('=== AI Plan Request ===');
      print('Body: $body');

      final result = await aiRepo.planTripMobile(body);

      print('=== AI Plan Result ===');
      print('Result: $result');

      if (result == null) {
        _error = 'No result returned from AI service';
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
        return false;
      }

      // Process the result internally without triggering notifications
      await _processAIPlanResultInternal(result);

      // Notify listeners after processing is complete
      notifyListeners();

      return true;
    } catch (e) {
      _error = 'Failed to generate AI plan: $e';
      print('Error in generateAndApplyAIPlan: $e');

      // Notify listeners about the error
      notifyListeners();

      return false;
    }
  }

  /// Internal method to process AI plan result without triggering notifications
  Future<void> _processAIPlanResultInternal(dynamic result) async {
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

        // Sort by sequence_number
        pois.sort(
          (a, b) => (a['sequence_number'] as int).compareTo(
            b['sequence_number'] as int,
          ),
        );

        // Create all itineraries for this day
        final dayItineraries = <ItineraryData>[];

        for (int i = 0; i < pois.length; i++) {
          final poi = pois[i];

          // Calculate the date for this day
          final date = trip!.startDate!.add(Duration(days: dayNumber - 1));

          // Create itinerary item
          final itinerary = ItineraryData(
            id: '', // Will be generated when synced
            placeId: poi['google_place_id'] ?? '',
            type: 'destination',
            date: date,
            userNotes: poi['name'] ?? '', // Use POI name as notes
            sequence: i,
            lastUpdated: DateTime.now(),
          );

          // Load place details sequentially to ensure each itinerary gets the correct place data
          await itinerary.loadPlaceDetails();
          dayItineraries.add(itinerary);
        }

        newItinerariesMap[dayNumber] = dayItineraries;
      }

      // Update the itineraries map using the proper method
      // Don't notify during the update, we'll notify once at the end after frame completes
      listToMap(
        newItinerariesMap.values.expand((list) => list).toList(),
        trip!.startDate!,
        trip!.endDate!,
        notify: false,
      );

      print('Successfully processed ${poisByDay.length} days of itinerary');

      // No notification here - caller will handle it
    } catch (e) {
      _error = 'Error processing AI result: $e';
      print('Error in _processAIPlanResultInternal: $e');

      // Don't notify here - caller will handle it
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

  // ==================== Lodging Methods ====================

  Future<void> loadLodgings() async {
    try {
      lodgings = await _lodgingRepo.fetchLodgings(trip!.tripId);
      print('Lodgings loaded: ${lodgings.length} items');
    } catch (e) {
      _error = 'Failed to load lodgings: $e';
      print('Error loading lodgings: $e');
    }
  }

  /// Map lodgings to days based on check-in to check-out date range
  void mapLodgingsByDay() {
    final Map<int, List<LodgingData>> dailyMap = {};

    // Initialize all days with empty lists
    final totalDays = trip!.endDate!.difference(trip!.startDate!).inDays + 1;
    for (int i = 1; i <= totalDays; i++) {
      dailyMap[i] = [];
    }

    // Assign lodgings to all days they span
    for (final lodging in lodgings) {
      final checkInDay = getDayNumber(
        lodging.checkInDateTime,
        trip!.startDate!,
      );
      final checkOutDay = getDayNumber(
        lodging.checkOutDateTime,
        trip!.startDate!,
      );

      // Add lodging to all days from check-in to check-out
      for (
        int day = checkInDay;
        day <= checkOutDay && day <= totalDays;
        day++
      ) {
        if (dailyMap.containsKey(day)) {
          dailyMap[day]!.add(lodging);
        }
      }
    }

    lodgingsMap = dailyMap;
    notifyListeners();
  }

  Future<void> addLodging(LodgingData lodging) async {
    try {
      final docId = await _lodgingRepo.addLodging(trip!.tripId, lodging);
      final newLodging = lodging.copyWith(id: docId);
      lodgings.add(newLodging);
      mapLodgingsByDay();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add lodging: $e';
      print('Error adding lodging: $e');
      rethrow;
    }
  }

  Future<void> updateLodging(LodgingData lodging) async {
    try {
      await _lodgingRepo.updateLodging(trip!.tripId, lodging);
      final index = lodgings.indexWhere((l) => l.id == lodging.id);
      if (index != -1) {
        lodgings[index] = lodging;
        mapLodgingsByDay();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update lodging: $e';
      print('Error updating lodging: $e');
      rethrow;
    }
  }

  Future<void> deleteLodging(String lodgingId) async {
    try {
      await _lodgingRepo.deleteLodging(trip!.tripId, lodgingId);
      lodgings.removeWhere((l) => l.id == lodgingId);
      mapLodgingsByDay();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete lodging: $e';
      print('Error deleting lodging: $e');
      rethrow;
    }
  }

  List<LodgingData> getLodgingsForDay(int day) {
    return lodgingsMap[day] ?? [];
  }

  /// Get place name from place ID using PlaceDetailsService
  Future<String?> getPlaceNameFromPlaceId(String placeId) async {
    try {
      final placeDetails = await PlaceDetailsService().fetchPlaceDetails(
        placeId,
      );
      return placeDetails?['name'] as String?;
    } catch (e) {
      print('Error fetching place name: $e');
      return null;
    }
  }

  // --- Flight Management ---
  Future<void> loadFlights() async {
    try {
      flights = await _flightRepo.fetchFlights(trip!.tripId);
      print('Flights loaded: ${flights.length} items');
    } catch (e) {
      _error = 'Failed to load flights: $e';
      print('Error loading flights: $e');
    }
  }

  void mapFlightsByDay() {
    final Map<int, List<FlightData>> dailyMap = {};

    // Initialize all days with empty lists
    final totalDays = getTotalDays();
    for (int i = 1; i <= totalDays; i++) {
      dailyMap[i] = [];
    }

    // Assign flights to the correct day based on the date field
    for (final flight in flights) {
      final day = getDayNumber(flight.date, trip!.startDate!);

      if (dailyMap.containsKey(day)) {
        dailyMap[day]!.add(flight);
      }
    }

    flightsMap = dailyMap;
    notifyListeners();
  }

  Future<void> addFlight(FlightData flight) async {
    try {
      final docId = await _flightRepo.addFlight(trip!.tripId, flight);
      final newFlight = flight.copyWith(id: docId);
      flights.add(newFlight);
      mapFlightsByDay();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to add flight: $e';
      print('Error adding flight: $e');
      rethrow;
    }
  }

  Future<void> updateFlight(FlightData flight) async {
    try {
      await _flightRepo.updateFlight(trip!.tripId, flight);
      final index = flights.indexWhere((f) => f.id == flight.id);
      if (index != -1) {
        flights[index] = flight;
        mapFlightsByDay();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to update flight: $e';
      print('Error updating flight: $e');
      rethrow;
    }
  }

  Future<void> deleteFlight(String flightId) async {
    try {
      await _flightRepo.deleteFlight(trip!.tripId, flightId);
      flights.removeWhere((f) => f.id == flightId);
      mapFlightsByDay();
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete flight: $e';
      print('Error deleting flight: $e');
      rethrow;
    }
  }

  List<FlightData> getFlightsForDay(int day) {
    return flightsMap[day] ?? [];
  }

  // ----- Publish/Share Itinerary -----
  Future<String?> publishItinerary({
    required String userName,
    String? userImageUrl,
  }) async {
    if (trip == null) return null;

    try {
      _isUploading = true;
      notifyListeners();

      // Check if already published
      final existingPost = await _postRepo.getPostByTripId(trip!.tripId);

      final post = PostData(
        postId: existingPost?.postId ?? '',
        userId: _postRepo.userId,
        tripId: trip!.tripId,
        tripName: trip!.tripName,
        destination: trip!.destination,
        startDate: trip!.startDate!,
        endDate: trip!.endDate!,
        travelersCount: trip!.travelersCount,
        tripImageUrl: trip!.tripImageUrl,
        userName: userName,
        userImageUrl: userImageUrl,
        lastPublished: DateTime.now(),
        lastUpdated: DateTime.now(),
        tripDeleted: false,
      );

      // Flatten itineraries from all days
      final List<ItineraryData> allItineraries = [];
      for (final dayItineraries in itinerariesMap.values) {
        allItineraries.addAll(dayItineraries);
      }

      debugPrint('📤 Publishing post with:');
      debugPrint('  - ${allItineraries.length} itineraries');
      debugPrint('  - ${lodgings.length} lodgings');
      debugPrint('  - ${flights.length} flights');

      final postId = await _postRepo.publishPost(
        post,
        allItineraries,
        lodgings,
        flights,
      );

      debugPrint('📝 Post published with ID: $postId, tripId: ${trip!.tripId}');

      _isUploading = false;
      notifyListeners();

      return postId;
    } catch (e) {
      _error = 'Failed to publish itinerary: $e';
      print('Error publishing itinerary: $e');
      _isUploading = false;
      notifyListeners();
      return null;
    }
  }

  Future<PostData?> getPublishedPost() async {
    if (trip == null) return null;
    try {
      return await _postRepo.getPostByTripId(trip!.tripId);
    } catch (e) {
      print('Error getting published post: $e');
      return null;
    }
  }

  // Unpublish the itinerary (delete the post)
  Future<void> unpublishItinerary() async {
    if (trip == null) return;

    try {
      _isUploading = true;
      notifyListeners();

      final existingPost = await _postRepo.getPostByTripId(trip!.tripId);

      if (existingPost != null) {
        await _postRepo.unpublishPost(existingPost.postId, trip!.tripId);
        debugPrint('🗑️ Post unpublished: ${existingPost.postId}');
      }

      _isUploading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to unpublish itinerary: $e';
      debugPrint('❌ Error unpublishing itinerary: $e');
      _isUploading = false;
      notifyListeners();
      rethrow;
    }
  }
}
