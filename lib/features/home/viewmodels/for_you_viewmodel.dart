import 'package:flutter/material.dart';
import 'package:tripora/core/services/for_you_recommender_service.dart';
import 'package:tripora/features/poi/models/poi.dart';
import 'package:tripora/core/repositories/collected_poi_repository.dart';
import 'package:tripora/core/repositories/poi_history_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class ForYouViewModel extends ChangeNotifier {
  final PageController pageController = PageController(viewportFraction: 0.85);
  final ForYouRecommenderService _recommenderService =
      ForYouRecommenderService();
  late final CollectedPoiRepository _collectedPoiRepository;
  late final PoiHistoryRepository _poiHistoryRepository;
  late final FirestoreService _firestoreService;

  int _currentPage = 0;
  bool _isLoading = false;
  String? _error;
  bool _isPersonalized = false;
  String? _userId;
  Map<String, bool> _collectionStatus = {}; // Track which POIs are collected

  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isPersonalized => _isPersonalized;

  List<Poi> destinations = [];
  bool _hasInitialized = false;

  ForYouViewModel({String? userId}) {
    _userId = userId;
    _firestoreService = FirestoreService();
    _collectedPoiRepository = CollectedPoiRepository(_firestoreService);
    _poiHistoryRepository = PoiHistoryRepository(_firestoreService);

    // Only initialize if user ID is already available
    if (_userId != null) {
      _initializeRecommendations();
    }
  }

  /// Set user ID for collection tracking
  void setUserId(String userId) {
    _userId = userId;

    // Initialize recommendations if not already done
    if (!_hasInitialized) {
      _initializeRecommendations();
    } else if (destinations.isNotEmpty) {
      _loadCollectionStatus();
    }
  }

  /// Check if a POI is collected by the current user
  bool isPoiCollected(String poiId) {
    return _collectionStatus[poiId] ?? false;
  }

  /// Load collection status for all destinations
  Future<void> _loadCollectionStatus() async {
    if (_userId == null) return;

    try {
      final collectedIds = await _collectedPoiRepository.getCollectedPoiIds(
        _userId!,
      );
      _collectionStatus = {};
      for (var id in collectedIds) {
        _collectionStatus[id] = true;
      }
      notifyListeners();
    } catch (e) {
      print('Error loading collection status: $e');
    }
  }

  /// Fetch user behavior (collected, trip, and viewed place IDs)
  Future<UserBehavior> _buildUserBehavior() async {
    if (_userId == null) {
      print('⚠️ User ID is null, skipping user behavior');
      return UserBehavior();
    }

    try {
      print('📥 Building user behavior for userId: $_userId');

      // Fetch collected place IDs
      final collectedIds = await _collectedPoiRepository.getCollectedPoiIds(
        _userId!,
      );
      print('✅ Collected POIs: ${collectedIds.length} - $collectedIds');

      // Fetch viewed place IDs from POI history (limit to 50 recent views)
      final poiHistory = await _poiHistoryRepository.getPoiHistory(
        _userId!,
        limit: 50,
      );
      final viewedIds = poiHistory.map((h) => h.placeId).toList();
      print('✅ Viewed POIs: ${viewedIds.length} - $viewedIds');

      // Fetch trip place IDs (get all trips and extract their itinerary place IDs)
      final trips = await _firestoreService.getTrips(_userId!);
      print('✅ Found ${trips.length} trips');
      final tripIds = <String>[];
      for (var trip in trips) {
        try {
          // Fetch itineraries for each trip (they're in a subcollection)
          final itineraries = await _firestoreService.getItineraries(
            _userId!,
            trip.tripId,
          );
          print('  📍 Trip ${trip.tripId}: ${itineraries.length} itineraries');
          for (var itinerary in itineraries) {
            if (itinerary.placeId.isNotEmpty) {
              tripIds.add(itinerary.placeId);
            }
          }
        } catch (e) {
          print('❌ Error fetching itineraries for trip ${trip.tripId}: $e');
        }
      }
      print('✅ Trip POIs: ${tripIds.length} - $tripIds');

      final behavior = UserBehavior(
        collectedPlaceIds: collectedIds,
        tripPlaceIds: tripIds,
        viewedPlaceIds: viewedIds,
      );

      print(
        '📊 User Behavior Summary - Collected: ${behavior.collectedPlaceIds.length}, Viewed: ${behavior.viewedPlaceIds.length}, Trips: ${behavior.tripPlaceIds.length}, isEmpty: ${behavior.isEmpty}',
      );

      return behavior;
    } catch (e) {
      print('❌ Error building user behavior: $e');
      return UserBehavior();
    }
  }

  /// Toggle collection status for a POI
  Future<void> togglePoiCollection(Poi poi) async {
    if (_userId == null) return;

    try {
      final newStatus = await _collectedPoiRepository.toggleCollection(
        _userId!,
        poi.id,
      );

      _collectionStatus[poi.id] = newStatus;
      notifyListeners();
    } catch (e) {
      print('Error toggling collection: $e');
      _error = 'Error updating collection: $e';
      notifyListeners();
    }
  }

  /// Initialize by loading recommendations from backend
  Future<void> _initializeRecommendations() async {
    _hasInitialized = true;
    await loadRecommendations();
  }

  /// Load recommendations from the backend service
  /// Automatically fetches user behavior for personalization
  Future<void> loadRecommendations({int topN = 5}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Build user behavior from database
      final userBehavior = await _buildUserBehavior();

      final finalBehavior = userBehavior.isEmpty ? null : userBehavior;
      print(
        '🔍 Final user behavior to send: ${finalBehavior == null ? "null (empty)" : finalBehavior.toJson()}',
      );

      final result = await _recommenderService.getForYouRecommendations(
        topN: topN,
        userBehavior: finalBehavior,
      );

      if (result['success'] == true) {
        final recommendations =
            result['recommendations'] as List<RecommendationModel>;
        _isPersonalized = result['isPersonalized'] as bool;

        // Convert RecommendationModel to Poi for UI
        // Filter out POIs without googlePlaceId and load full details
        final filteredRecommendations = recommendations
            .where(
              (rec) =>
                  rec.googlePlaceId != null && rec.googlePlaceId!.isNotEmpty,
            )
            .toList();

        try {
          // Load full POI details for each recommendation
          destinations = await Future.wait(
            filteredRecommendations
                .map((rec) => Poi.fromPlaceId(rec.googlePlaceId!))
                .toList(),
          );

          // Load collection status for the new destinations
          await _loadCollectionStatus();
        } catch (e) {
          _error = 'Error loading POI details: $e';
          print(_error);
          // Fallback to basic POI objects if detailed fetch fails
          destinations = filteredRecommendations
              .map(
                (rec) => Poi(
                  id: rec.googlePlaceId!,
                  name: rec.name,
                  country: rec.state,
                  lat: rec.latitude,
                  lng: rec.longitude,
                  rating: rec.googleRating ?? 4.5,
                  imageUrl: rec.imageUrl,
                ),
              )
              .toList();

          await _loadCollectionStatus();
        }

        // Reset page controller
        _currentPage = 0;
      } else {
        _error = result['error'] as String? ?? 'Failed to load recommendations';
      }
    } catch (e) {
      _error = 'Error loading recommendations: $e';
      print(_error);
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refresh recommendations
  Future<void> refreshRecommendations() async {
    await loadRecommendations();
  }

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
