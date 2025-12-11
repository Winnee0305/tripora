import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/models/lodging_data.dart';

class LodgingRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  LodgingRepository(this._firestore, this._uid);

  // Fetch all lodgings for a trip
  Future<List<LodgingData>> fetchLodgings(String tripId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .where('type', isEqualTo: 'lodging')
          .get();

      return snapshot.docs
          .map((doc) => LodgingData.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch lodgings: $e');
    }
  }

  // Add a new lodging
  Future<String> addLodging(String tripId, LodgingData lodging) async {
    try {
      final lodgingId = (lodging.id.isNotEmpty)
          ? lodging.id
          : _firestore
                .collection('users')
                .doc(_uid)
                .collection('trips')
                .doc(tripId)
                .collection('itineraries')
                .doc()
                .id;

      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc(lodgingId)
          .set(
            lodging.copyWith(id: lodgingId).toMap(),
            SetOptions(merge: true),
          );

      return lodgingId;
    } catch (e) {
      throw Exception('Failed to add lodging: $e');
    }
  }

  // Update an existing lodging
  Future<void> updateLodging(String tripId, LodgingData lodging) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc(lodging.id)
          .update(lodging.toMap());
    } catch (e) {
      throw Exception('Failed to update lodging: $e');
    }
  }

  // Delete a lodging
  Future<void> deleteLodging(String tripId, String lodgingId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc(lodgingId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete lodging: $e');
    }
  }

  // Stream lodgings for real-time updates
  Stream<List<LodgingData>> streamLodgings(String tripId) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .where('type', isEqualTo: 'lodging')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LodgingData.fromFirestore(doc))
              .toList(),
        );
  }
}
