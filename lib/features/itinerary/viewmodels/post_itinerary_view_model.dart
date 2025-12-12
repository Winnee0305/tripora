import 'package:flutter/material.dart';
import 'package:tripora/core/models/flight_data.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/lodging_data.dart';
import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/poi/models/poi.dart';

/// ViewModel for loading and displaying post itinerary data in read-only mode
class PostItineraryViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final String postId;

  PostItineraryViewModel(this._firestoreService, this.postId);

  // --- Local states ---
  List<ItineraryData> itineraries = [];
  Map<int, List<ItineraryData>> itinerariesMap = {};
  List<LodgingData> lodgings = [];
  Map<int, List<LodgingData>> lodgingsMap = {};
  List<FlightData> flights = [];
  Map<int, List<FlightData>> flightsMap = {};
  bool _isLoading = true; // Start with loading state
  String? _error;
  PostData? postData; // Expose post data for UI
  DateTime? _tripStartDate;
  TripData? trip; // For compatibility with ItineraryViewModel interface

  // --- Getters ---
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get tripName => postData?.tripName;
  DateTime? get startDate => postData?.startDate;
  DateTime? get endDate => postData?.endDate;

  /// Load all itinerary data from the post's subcollections
  Future<void> loadPostData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('📥 Loading post data for postId: $postId');
      // Load post data to get trip start date
      postData = await _firestoreService.getPost(postId);
      if (postData == null) {
        throw Exception('Post not found');
      }
      debugPrint('✅ Post data loaded: ${postData!.tripName}');
      _tripStartDate = postData!.startDate;
      debugPrint('📅 Trip start date: $_tripStartDate');

      // Create TripData for compatibility with ItineraryViewModel interface
      trip = TripData(
        tripId: postData!.postId,
        tripName: postData!.tripName,
        startDate: postData!.startDate,
        endDate: postData!.endDate,
        destination: postData!.destination,
        travelStyle: '', // Not available from post
        travelPartnerType: '', // Not available from post
        travelersCount: postData!.travelersCount,
        tripImageUrl: postData!.tripImageUrl,
        lastUpdated: postData!.lastUpdated,
      );

      // Load all subcollections in parallel
      debugPrint('📦 Loading subcollections...');
      try {
        final results = await Future.wait([
          _firestoreService.getPostItineraries(postId),
          _firestoreService.getPostLodgings(postId),
          _firestoreService.getPostFlights(postId),
        ]);
        debugPrint('📦 Future.wait completed');

        itineraries = results[0] as List<ItineraryData>;
        lodgings = results[1] as List<LodgingData>;
        flights = results[2] as List<FlightData>;
        debugPrint(
          '✅ Loaded ${itineraries.length} itineraries, ${lodgings.length} lodgings, ${flights.length} flights',
        );
      } catch (subError) {
        debugPrint('❌ Error loading subcollections: $subError');
        debugPrint('Stack trace: ${StackTrace.current}');
        rethrow;
      }

      // Organize data by day
      _organizeItinerariesByDay();
      _organizeLodgingsByDay();
      _organizeFlightsByDay();
      debugPrint('📊 Organized data by day:');
      debugPrint('   - itinerariesMap keys: ${itinerariesMap.keys.toList()}');
      debugPrint('   - lodgingsMap keys: ${lodgingsMap.keys.toList()}');
      debugPrint('   - flightsMap keys: ${flightsMap.keys.toList()}');
      debugPrint('   - trip: ${trip?.tripName}, startDate: ${trip?.startDate}');

      // Load place details for each itinerary
      await _loadPlaceDetails();

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to load post data: $e');
      debugPrint('Stack trace: $stackTrace');
      _error = 'Failed to load post data: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  int _getDayNumber(DateTime itemDate) {
    if (_tripStartDate == null) return 1;
    return itemDate.difference(_tripStartDate!).inDays + 1;
  }

  void _organizeItinerariesByDay() {
    itinerariesMap.clear();
    debugPrint('🔄 Organizing ${itineraries.length} itineraries by day...');
    for (final itinerary in itineraries) {
      final dayNumber = _getDayNumber(itinerary.date);
      debugPrint(
        '   - Itinerary [${itinerary.type}] placeId: ${itinerary.placeId} on day $dayNumber',
      );
      if (!itinerariesMap.containsKey(dayNumber)) {
        itinerariesMap[dayNumber] = [];
      }
      itinerariesMap[dayNumber]!.add(itinerary);
    }
    // Sort each day's itineraries by sequence
    for (final day in itinerariesMap.keys) {
      itinerariesMap[day]!.sort((a, b) => a.sequence.compareTo(b.sequence));
    }
  }

  void _organizeLodgingsByDay() {
    lodgingsMap.clear();
    for (final lodging in lodgings) {
      final dayNumber = _getDayNumber(lodging.date);
      if (!lodgingsMap.containsKey(dayNumber)) {
        lodgingsMap[dayNumber] = [];
      }
      lodgingsMap[dayNumber]!.add(lodging);
    }
  }

  void _organizeFlightsByDay() {
    flightsMap.clear();
    for (final flight in flights) {
      final dayNumber = _getDayNumber(flight.date);
      if (!flightsMap.containsKey(dayNumber)) {
        flightsMap[dayNumber] = [];
      }
      flightsMap[dayNumber]!.add(flight);
    }
  }

  /// Load place details for all destination itineraries
  Future<void> _loadPlaceDetails() async {
    debugPrint(
      '🏢 Loading place details for ${itineraries.length} itineraries...',
    );

    // Filter out notes and get only destinations with placeIds
    final destinationItineraries = itineraries
        .where((it) => it.isDestination && it.placeId.isNotEmpty)
        .toList();

    if (destinationItineraries.isEmpty) {
      debugPrint('   - No destinations to load');
      return;
    }

    debugPrint('   - Loading ${destinationItineraries.length} place details');

    // Load place details in parallel (but limit concurrency to avoid overload)
    final batchSize = 5; // Load 5 at a time
    for (var i = 0; i < destinationItineraries.length; i += batchSize) {
      final end = (i + batchSize < destinationItineraries.length)
          ? i + batchSize
          : destinationItineraries.length;
      final batch = destinationItineraries.sublist(i, end);

      await Future.wait(
        batch.map((itinerary) async {
          try {
            final place = await Poi.fromPlaceId(itinerary.placeId);
            itinerary.place = place;
            debugPrint('   ✅ Loaded place: ${place.name}');
          } catch (e) {
            debugPrint('   ❌ Failed to load place ${itinerary.placeId}: $e');
          }
        }),
      );
    }

    debugPrint('✅ Finished loading place details');
  }
}
