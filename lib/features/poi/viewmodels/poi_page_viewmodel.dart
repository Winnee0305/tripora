import 'package:flutter/foundation.dart';
import 'package:tripora/core/repositories/collected_poi_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/poi/models/poi.dart';

class PoiPageViewmodel extends ChangeNotifier {
  Poi? poi;
  bool isLoading = true;
  late CollectedPoiRepository _collectedPoiRepository;
  bool _isCollected = false;
  int _collectsCount = 0;

  bool get isCollected => _isCollected;
  int get collectsCount => _collectsCount;

  PoiPageViewmodel(String placeId, {String? userId}) {
    _collectedPoiRepository = CollectedPoiRepository(FirestoreService());
    _init(placeId, userId);
  }

  Future<void> _init(String placeId, String? userId) async {
    try {
      // Load POI details immediately
      poi = await Poi.fromPlaceId(placeId);

      // Load collection status if user is provided
      if (userId != null && poi != null) {
        _isCollected = await _collectedPoiRepository.isCollected(userId, placeId);
      }

      // Initialize collects count from POI if available
      _collectsCount = poi?.collectsCount ?? 0;
    } catch (e) {
      if (kDebugMode) print("Error loading POI: $e");
      poi = Poi(id: placeId); // fallback
    } finally {
      isLoading = false;
      notifyListeners(); // rebuild UI with POI info
    }

    // Fetch AI description separately, after init
    if (poi != null) {
      poi!.loadDesc().then((_) {
        notifyListeners(); // rebuild UI when description is ready
      });
      poi!.loadNearbyAttractions().then((_) {
        notifyListeners(); // rebuild UI when nearby attractions are ready
      });
    }
  }

  /// Toggle the collection status of the POI
  Future<void> toggleCollection(String userId) async {
    try {
      if (poi == null) return;

      final newState = await _collectedPoiRepository.toggleCollection(
        userId,
        poi!.id,
      );

      _isCollected = newState;
      _collectsCount += newState ? 1 : -1;
      notifyListeners();

      if (kDebugMode) {
        print('✅ POI ${poi!.id} collection toggled: $_isCollected');
      }
    } catch (e) {
      if (kDebugMode) print("Error toggling collection: $e");
      rethrow;
    }
  }
}
