import 'package:tripora/core/services/firebase_firestore_service.dart';

class CollectedPoiRepository {
  final FirestoreService _firestoreService;

  CollectedPoiRepository(this._firestoreService);

  /// Add a POI to user's collected POIs
  Future<void> addToCollection(String uid, String poiId) async {
    await _firestoreService.addToCollectedPois(uid, poiId);
  }

  /// Remove a POI from user's collected POIs
  Future<void> removeFromCollection(String uid, String poiId) async {
    await _firestoreService.removeFromCollectedPois(uid, poiId);
  }

  /// Check if a POI is in user's collection
  Future<bool> isCollected(String uid, String poiId) async {
    return await _firestoreService.isPoiCollected(uid, poiId);
  }

  /// Get all collected POI IDs for a user
  Future<List<String>> getCollectedPoiIds(String uid) async {
    return await _firestoreService.getCollectedPoiIds(uid);
  }

  /// Toggle collection status (add if not collected, remove if collected)
  Future<bool> toggleCollection(String uid, String poiId) async {
    final isCollected = await this.isCollected(uid, poiId);
    if (isCollected) {
      await removeFromCollection(uid, poiId);
      return false; // Now not collected
    } else {
      await addToCollection(uid, poiId);
      return true; // Now collected
    }
  }
}
