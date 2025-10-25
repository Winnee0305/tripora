import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/models/itinerary_item_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/models/user_data.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  // ----- User Profile -----
  Future<UserData?> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.exists ? UserData.fromFirestore(doc) : null;
  }

  Future<void> updateUser(UserData user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  // ----- User - Trips
  Future<void> addTrip(String uid, TripData trip) async {
    final tripId = trip.tripId.isNotEmpty == true
        ? trip.tripId
        : _firestore.collection('users').doc(uid).collection('trips').doc().id;

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .set(trip.copyWith(tripId: tripId).toMap());
  }

  Future<List<TripData>> getTrips(String uid) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('trips')
        .get();
    return snapshot.docs.map(TripData.fromFirestore).toList();
  }

  // User - Trips - Itinerary
  Future<void> addItineraryItem(
    String uid,
    String tripId,
    ItineraryItemData itineraryItemData,
  ) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itinerary')
        .doc(itineraryItemData.id)
        .set(itineraryItemData.toMap());
  }

  Future<List<ItineraryItemData>> getItineraryItems(
    String uid,
    String tripId,
  ) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itinerary')
        .get();
    return snapshot.docs.map(ItineraryItemData.fromFirestore).toList();
  }
}
