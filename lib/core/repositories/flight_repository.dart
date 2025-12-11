import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/models/flight_data.dart';

class FlightRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  FlightRepository(this._firestore, this._uid);

  // Fetch all flights for a trip
  Future<List<FlightData>> fetchFlights(String tripId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc('data')
          .collection('flights')
          .get();

      return snapshot.docs.map((doc) => FlightData.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch flights: $e');
    }
  }

  // Add a new flight
  Future<String> addFlight(String tripId, FlightData flight) async {
    try {
      final flightId = (flight.id.isNotEmpty)
          ? flight.id
          : _firestore
                .collection('users')
                .doc(_uid)
                .collection('trips')
                .doc(tripId)
                .collection('itineraries')
                .doc('data')
                .collection('flights')
                .doc()
                .id;

      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc('data')
          .collection('flights')
          .doc(flightId)
          .set(flight.copyWith(id: flightId).toMap(), SetOptions(merge: true));

      return flightId;
    } catch (e) {
      throw Exception('Failed to add flight: $e');
    }
  }

  // Update an existing flight
  Future<void> updateFlight(String tripId, FlightData flight) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc('data')
          .collection('flights')
          .doc(flight.id)
          .update(flight.toMap());
    } catch (e) {
      throw Exception('Failed to update flight: $e');
    }
  }

  // Delete a flight
  Future<void> deleteFlight(String tripId, String flightId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc('data')
          .collection('flights')
          .doc(flightId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete flight: $e');
    }
  }

  // Stream flights for real-time updates
  Stream<List<FlightData>> streamFlights(String tripId) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .doc('data')
        .collection('flights')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FlightData.fromFirestore(doc))
              .toList(),
        );
  }
}
