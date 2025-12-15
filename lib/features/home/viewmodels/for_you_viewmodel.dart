import 'package:flutter/material.dart';
import 'package:tripora/core/services/for_you_recommender_service.dart';
import 'package:tripora/features/poi/models/poi.dart';
import 'package:tripora/core/repositories/collected_poi_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class ForYouViewModel extends ChangeNotifier {
  final PageController pageController = PageController(viewportFraction: 0.85);
  final ForYouRecommenderService _recommenderService =
      ForYouRecommenderService();
  late final CollectedPoiRepository _collectedPoiRepository;

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

  ForYouViewModel({String? userId}) {
    _userId = userId;
    _collectedPoiRepository = CollectedPoiRepository(FirestoreService());
    _initializeRecommendations();
  }

  /// Set user ID for collection tracking
  void setUserId(String userId) {
    _userId = userId;
    if (destinations.isNotEmpty) {
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
    await loadRecommendations();
  }

  /// Load recommendations from the backend service
  /// Can optionally include user behavior for personalization
  Future<void> loadRecommendations({
    UserBehavior? userBehavior,
    int topN = 5,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _recommenderService.getForYouRecommendations(
        topN: topN,
        userBehavior: userBehavior,
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

  /// Refresh recommendations (useful for getting new variety)
  Future<void> refreshRecommendations({UserBehavior? userBehavior}) async {
    await loadRecommendations(userBehavior: userBehavior);
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
