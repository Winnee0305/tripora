import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/models/user_data.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get usersCollection =>
      _firestore.collection('users');

  // ----- User Profile -----
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDoc(String uid) {
    return usersCollection.doc(uid).get();
  }

  Future<UserData?> getUser(String uid) async {
    final doc = await usersCollection.doc(uid).get();
    return doc.exists ? UserData.fromFirestore(doc) : null;
  }

  // Future<void> updateUser(UserData user) async {
  //   await _firestore.collection('users').doc(user.uid).update(user.toMap());
  // }
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await usersCollection.doc(uid).update(data);
    } on FirebaseException catch (e) {
      // Optional: handle specific Firestore errors (e.g., not found)
      if (e.code == 'not-found') {
        // If the doc doesn't exist, create it instead
        await usersCollection.doc(uid).set(data);
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // ----- User - Trips
  Future<DocumentSnapshot<Map<String, dynamic>>> getTripDoc(
    String uid,
    String tripId,
  ) {
    return usersCollection.doc(uid).collection('trips').doc(tripId).get();
  }

  Future<void> addTrip(String uid, TripData trip) async {
    final tripId = trip.tripId.isNotEmpty == true
        ? trip.tripId
        : usersCollection.doc(uid).collection('trips').doc().id;

    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .set(trip.copyWith(tripId: tripId).toMap());
  }

  Future<List<TripData>> getTrips(String uid) async {
    final snapshot = await usersCollection.doc(uid).collection('trips').get();
    return snapshot.docs.map(TripData.fromFirestore).toList();
  }

  // Future<void> deleteTrip(String uid, String tripId) async {
  //   await usersCollection.doc(uid).collection('trips').doc(tripId).delete();
  // }
  Future<void> deleteTrip(String uid, String tripId) async {
    try {
      await usersCollection.doc(uid).collection('trips').doc(tripId).delete();
      print('Trip deleted: $tripId');
    } catch (e) {
      print('Failed to delete trip: $e');
    }
  }

  Future<void> updateTrip(String uid, TripData trip) async {
    // Update the trip document in Firestore
    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(trip.tripId)
        .update(trip.toMap());

    // Additional step: remove the trip image in firestore
  }

  // ----- User - Trip - Itineraries -----
  Future<DocumentSnapshot<Map<String, dynamic>>> getItineraryDoc(
    String uid,
    String tripId,
    String itineraryId,
  ) {
    return usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .doc(itineraryId)
        .get();
  }

  Future<void> addItinerary(
    String uid,
    ItineraryData itinerary,
    String tripId,
  ) async {
    print('Adding itinerary for tripId: $tripId');
    // Use existing id if present, otherwise generate a new one
    final itineraryId = (itinerary.id.isNotEmpty)
        ? itinerary.id
        : usersCollection
              .doc(uid)
              .collection('trips')
              .doc(tripId)
              .collection('itineraries')
              .doc()
              .id;

    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .doc(itineraryId)
        .set(
          itinerary.copyWith(id: itineraryId).toMap(),
          SetOptions(merge: true),
        );
  }

  Future<List<ItineraryData>> getItineraries(String uid, String tripId) async {
    final snapshot = await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .get();
    return snapshot.docs.map(ItineraryData.fromFirestore).toList();
  }

  // Future<void> deleteTrip(String uid, String tripId) async {
  //   await usersCollection.doc(uid).collection('trips').doc(tripId).delete();
  // }
  Future<void> deleteItinerary(
    String uid,
    String itineraryId,
    String tripId,
  ) async {
    try {
      await usersCollection
          .doc(uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc(itineraryId)
          .delete();
      print('Itinerary deleted: $itineraryId');
    } catch (e) {
      print('Failed to delete itinerary: $e');
    }
  }

  Future<void> updateItinerary(
    String uid,
    ItineraryData itinerary,
    String tripId,
  ) async {
    // Update the itinerary document in Firestore
    await usersCollection
        .doc(uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .doc(itinerary.id)
        .update(itinerary.toMap());
  }

  // Future<void> updateTrip(String uid, TripData trip) async {
  //   // Update the trip document in Firestore
  //   await usersCollection
  //       .doc(uid)
  //       .collection('trips')
  //       .doc(trip.tripId)
  //       .update(trip.toMap());

  // Additional step: remove the trip image in firestore
}
