import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tripora/features/trip/models/trip_data.dart';
import 'package:tripora/core/repositories/trip_repository.dart';

class TripViewModel extends ChangeNotifier {
  final TripRepository _tripRepo;

  TripViewModel(this._tripRepo);

  // --- Local states ---
  List<TripData> _trips = [];
  TripData? _selectedTrip;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _error;

  // --- Getters ---
  List<TripData> get trips => _trips;
  TripData? get trip => _selectedTrip;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get error => _error;

  // ==========================
  // 🔹 LIST OPERATIONS
  // ==========================
  Future<void> loadTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _trips = await _tripRepo.getTrips();
      // Sort trips by latest lastUpdated first
      _trips.sort((a, b) {
        final aDate = a.lastUpdated != null ? a.lastUpdated! : DateTime(1970);
        final bDate = b.lastUpdated != null ? b.lastUpdated! : DateTime(1970);
        return bDate.compareTo(aDate);
      });
    } catch (e) {
      _error = 'Failed to load trips: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSelectedTrip(TripData trip) {
    _selectedTrip = trip;
    notifyListeners();
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await _tripRepo.deleteTrip(tripId);
      await loadTrips(); // reload list
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete trip: $e';
      notifyListeners();
    }
  }

  Future<void> writeTrip(TripData trip, bool isCreate) async {
    TripData updatedTrip = trip;
    _isUploading = true;
    notifyListeners();

    try {
      // ✅ Only run upload logic if trip image path is not null and not same as selected trip
      if (trip.tripImageUrl != "" &&
          trip.tripImageUrl != _selectedTrip?.tripImageUrl) {
        final file = File(trip.tripImageUrl!);

        debugPrint("📸 Uploading new trip image for trip: ${trip.tripId}");

        final result = await _tripRepo.uploadTripImage(
          tripId: trip.tripId,
          file: file,
          onProgress: (progress) {
            debugPrint(
              '📤 Upload progress: ${(progress * 100).toStringAsFixed(1)}%',
            );
          },
        );

        if (result['downloadUrl'] != null && result['storagePath'] != null) {
          updatedTrip = trip.copyWith(
            tripImageUrl: result['downloadUrl'],
            tripStoragePath: result['storagePath'],
          );
        }
      } else {
        debugPrint("ℹ️ No trip image provided — skipping upload.");
      }

      // ✅ Update trip data in Firestore
      await (isCreate
          ? _tripRepo.createTrip(updatedTrip)
          : _tripRepo.updateTrip(updatedTrip));
      debugPrint("✅ Trip updated successfully: ${trip.tripId}");
    } catch (e, stack) {
      debugPrint("❌ Failed to update trip: $e");
      debugPrint(stack.toString());
    } finally {
      await loadTrips();
      selectLastestTrip();
      _isUploading = false;
      notifyListeners();
    }
  }

  void newTrip() {
    _selectedTrip = TripData.empty();
    notifyListeners();
  }

  void createTrip(TripData trip) {
    loadTrips();
    notifyListeners();
  }

  void selectLastestTrip() {
    if (_trips.isNotEmpty) {
      _selectedTrip = _trips.first;
      print("Selected latest trip: ${_selectedTrip!.tripName}");
    } else {
      _selectedTrip = null;
    }
    notifyListeners();
  }

  // Future<void> saveTrip() async {
  //   if (_selectedTrip == null) return;
  //   await _tripRepo.addTrip(_selectedTrip!);
  //   await loadTrips(); // reload list after saving
  // }

  // ==========================
  //  Trip field setters
  // ==========================
  void setTripName(String name) {
    _selectedTrip = _selectedTrip?.copyWith(tripName: name);
    notifyListeners();
  }

  void setDestination(String destination) {
    _selectedTrip = _selectedTrip?.copyWith(destination: destination);
    notifyListeners();
  }

  void setTravelStyle(String style) {
    _selectedTrip = _selectedTrip?.copyWith(travelStyle: style);
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _selectedTrip = _selectedTrip?.copyWith(startDate: start, endDate: end);
    notifyListeners();
  }

  void setTravelPartner(String partner) {
    _selectedTrip = _selectedTrip?.copyWith(travelPartnerType: partner);
    notifyListeners();
  }

  void setNumTravellers(int num) {
    _selectedTrip = _selectedTrip?.copyWith(travelersCount: num);
    notifyListeners();
  }
}
