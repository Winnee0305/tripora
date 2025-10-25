import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/services/firestore_service.dart';
import 'package:tripora/core/services/auth_service.dart'; // or your AuthState class

class TripRepository {
  final FirestoreService _firestore;
  final String uid; // The current user's ID

  TripRepository(this._firestore, this.uid);

  // ---- CREATE ----
  Future<void> createTrip(TripData trip) async {
    await _firestore.addTrip(uid, trip);
  }

  // // ---- READ (Single) ----
  // Future<TripData?> getTrip(String tripId) async {
  //   return await _firestore.getTrip(uid, tripId);
  // }

  // ---- READ (All for user) ----
  Future<List<TripData>> getTrips() async {
    return await _firestore.getTrips(uid);
  }

  // // ---- UPDATE ----
  // Future<void> updateTrip(TripData trip) async {
  //   await _firestore.updateTrip(uid, trip);
  // }

  // // ---- DELETE ----
  // Future<void> deleteTrip(String tripId) async {
  //   await _firestore.deleteTrip(uid, tripId);
  // }
}
