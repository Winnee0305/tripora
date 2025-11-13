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
  String? _error;

  // --- Getters ---
  List<TripData> get trips => _trips;
  TripData? get trip => _selectedTrip;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get debugCheck => _tripRepo.uid;

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

  // Future<void> deleteTrip(String tripId) async {
  //   try {
  //     await _tripRepo.deleteTrip(tripId);
  //     _trips.removeWhere((t) => t.tripId == tripId);
  //     notifyListeners();
  //   } catch (e) {
  //     _error = 'Failed to delete trip: $e';
  //     notifyListeners();
  //   }
  // }

  // ==========================
  // 🔹 SINGLE TRIP OPERATIONS
  // ==========================
  // Future<void> loadTrip(String tripId) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     _selectedTrip = await _tripRepo.getTrip(tripId);
  //   } catch (e) {
  //     _error = 'Failed to load trip: $e';
  //   }

  //   _isLoading = false;
  //   notifyListeners();
  // }

  void newTrip() {
    _selectedTrip = TripData.empty();
    notifyListeners();
  }

  void createTrip(TripData trip) {
    _tripRepo.createTrip(trip);
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
