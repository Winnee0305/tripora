import 'package:flutter/foundation.dart';
import 'package:tripora/core/repositories/collected_poi_repository.dart';
import 'package:tripora/core/repositories/poi_history_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/poi/models/poi.dart';

class PoiPageViewmodel extends ChangeNotifier {
  Poi? poi;
  bool isLoading = true;
  late CollectedPoiRepository _collectedPoiRepository;
  late PoiHistoryRepository _historyRepository;
  bool _isCollected = false;
  int _collectsCount = 0;
  final String? userId;

  bool get isCollected => _isCollected;
  int get collectsCount => _collectsCount;

  PoiPageViewmodel(String placeId, {this.userId}) {
    final firestoreService = FirestoreService();
    _collectedPoiRepository = CollectedPoiRepository(firestoreService);
    _historyRepository = PoiHistoryRepository(firestoreService);
    _init(placeId);
  }

  Future<void> _init(String placeId) async {
    try {
      // Load POI details immediately
      poi = await Poi.fromPlaceId(placeId);

      // Load collection status if user is provided
      if (userId != null && poi != null) {
        _isCollected = await _collectedPoiRepository.isCollected(
          userId!,
          placeId,
        );
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

    // Record POI view to history if user is logged in
    if (userId != null && poi != null) {
      await recordPoiView(userId!);
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

  /// Record POI view to user's history
  Future<void> recordPoiView(String uid) async {
    try {
      if (poi == null) return;

      await _historyRepository.recordPoiView(
        uid: uid,
        placeId: poi!.id,
        poiName: poi!.name,
        address: poi!.address,
        tags: poi!.tags,
      );

      if (kDebugMode) print('✅ POI view recorded: ${poi!.name}');
    } catch (e) {
      if (kDebugMode) print('⚠️ Error recording POI view: $e');
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
