import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/models/itinerary_data.dart';
import 'package:tripora/core/services/firebase_storage_service.dart';
import 'package:tripora/core/utils/image_utils.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/core/services/firebase_auth_service.dart'; // or your AuthState class

class ItineraryRepository {
  final FirestoreService _firestoreService;
  final FirebaseStorageService _storageService;
  final String _uid; // The current user's ID

  ItineraryRepository(this._firestoreService, this._uid, this._storageService);
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
