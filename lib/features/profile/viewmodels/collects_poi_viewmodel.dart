import 'package:flutter/foundation.dart';
import 'package:tripora/core/repositories/collected_poi_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/poi/models/poi.dart';

class CollectsPoiViewModel extends ChangeNotifier {
  final CollectedPoiRepository _collectedPoiRepository;
  final String userId;

  List<String> _collectedPoiIds = [];
  Map<String, Poi> _poisMap = {};
  bool _isLoading = false;

  List<Poi> get collectedPois =>
      _collectedPoiIds.map((id) => _poisMap[id]).whereType<Poi>().toList();

  bool get isLoading => _isLoading;

  CollectsPoiViewModel(
    this._collectedPoiRepository,
    FirestoreService firestoreService,
    this.userId,
  ) {
    _init();
  }

  Future<void> _init() async {
    await refreshCollectedPois();
  }

  /// Fetch all collected POI IDs and their details
  Future<void> refreshCollectedPois() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Get all collected POI IDs
      _collectedPoiIds = await _collectedPoiRepository.getCollectedPoiIds(
        userId,
      );

      if (kDebugMode) {
        print('Collected POI IDs: $_collectedPoiIds');
      }

      // Fetch POI details for each ID
      _poisMap.clear();
      for (final poiId in _collectedPoiIds) {
        try {
          if (kDebugMode) {
            print('Loading POI: $poiId');
          }
          final poi = await Poi.fromPlaceId(poiId);
          _poisMap[poiId] = poi;
          if (kDebugMode) {
            print('✅ Loaded POI: ${poi.name}');
          }
        } catch (e) {
          if (kDebugMode) print("Error loading POI $poiId: $e");
        }
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) print("Error refreshing collected POIs: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Remove a POI from collection
  Future<void> removeFromCollection(String poiId) async {
    try {
      await _collectedPoiRepository.removeFromCollection(userId, poiId);
      _collectedPoiIds.remove(poiId);
      _poisMap.remove(poiId);
      notifyListeners();

      if (kDebugMode) {
        print('✅ POI $poiId removed from collection');
      }
    } catch (e) {
      if (kDebugMode) print("Error removing POI from collection: $e");
      rethrow;
    }
  }
}
