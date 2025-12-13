import 'package:tripora/core/models/poi_history_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class PoiHistoryRepository {
  final FirestoreService _firestoreService;

  PoiHistoryRepository(this._firestoreService);

  /// Record a POI view to user's history
  Future<void> recordPoiView({
    required String uid,
    required String placeId,
    required String poiName,
    required String address,
    required List<String> tags,
  }) async {
    await _firestoreService.recordPoiViewHistory(
      uid: uid,
      placeId: placeId,
      poiName: poiName,
      address: address,
      tags: tags,
    );
  }

  /// Get user's POI view history (with optional limit)
  Future<List<PoiHistoryData>> getPoiHistory(
    String uid, {
    int limit = 50,
  }) async {
    return await _firestoreService.getPoiViewHistory(uid, limit: limit);
  }

  /// Delete a specific POI history entry
  Future<void> deleteHistoryEntry(String uid, String historyId) async {
    await _firestoreService.deletePoiHistoryEntry(uid, historyId);
  }

  /// Clear all POI history for a user
  Future<void> clearAllHistory(String uid) async {
    await _firestoreService.clearAllPoiHistory(uid);
  }

  /// Get POI history grouped by date (for analytics)
  Future<Map<String, List<PoiHistoryData>>> getPoiHistoryByDate(
    String uid, {
    int limit = 50,
  }) async {
    final history = await getPoiHistory(uid, limit: limit);
    final grouped = <String, List<PoiHistoryData>>{};

    for (final item in history) {
      final dateKey = _getDateKey(item.viewedAt);
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(item);
    }

    return grouped;
  }

  /// Helper to format date as YYYY-MM-DD for grouping
  String _getDateKey(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}
