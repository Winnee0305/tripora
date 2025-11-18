import 'dart:async';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class ItineraryRepository {
  final FirestoreService _firestoreService;
  final String _uid; // The current user's ID

  ItineraryRepository(this._firestoreService, this._uid);
  // ---- CREATE ----
  Future<void> createItinerary(ItineraryData itinerary, String tripId) async {
    await _firestoreService.addItinerary(_uid, itinerary, tripId);
  }

  // ---- READ (All for this trip) ----
  Future<List<ItineraryData>> getItineraries(String tripId) async {
    return await _firestoreService.getItineraries(_uid, tripId);
  }

  // ---- DELETE ----
  Future<void> deleteItinerary(String itineraryId, String tripId) async {
    await _firestoreService.deleteItinerary(_uid, itineraryId, tripId);
  }

  // ---- UPDATE ----
  Future<void> updateItinerary(ItineraryData itinerary, String tripId) async {
    await _firestoreService.updateItinerary(_uid, itinerary, tripId);
  }
}
