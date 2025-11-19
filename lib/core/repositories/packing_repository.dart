import 'package:tripora/core/models/packing_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class PackingRepository {
  final FirestoreService _firestoreService;
  final String _uid; // The current user's ID

  PackingRepository(this._firestoreService, this._uid);
  // ---- CREATE ----
  Future<void> addPackingItem(PackingData packingItem, String tripId) async {
    await _firestoreService.addPackingItem(_uid, packingItem, tripId);
  }

  // ---- READ (All for this trip) ----
  Future<List<PackingData>> getPackingItems(String tripId) async {
    return await _firestoreService.getPackingItems(_uid, tripId);
  }

  // // ---- DELETE ----
  Future<void> deletePackingItems(String packingItemId, String tripId) async {
    await _firestoreService.deletePackingItem(_uid, packingItemId, tripId);
  }

  // // ---- UPDATE ----
  Future<void> updatePackingItem(PackingData packingItem, String tripId) async {
    await _firestoreService.updatePackingItem(_uid, packingItem, tripId);
  }
}
