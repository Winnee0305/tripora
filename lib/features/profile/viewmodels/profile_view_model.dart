import 'package:flutter/material.dart';
import 'package:tripora/core/models/user_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:tripora/features/exploration/models/travel_post.dart';

class ProfileViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  late UserData user;

  List<Post> collects = [];

  int _tripsCreatedCount = 0;
  int _sharedTripsCount = 0;
  int _collectionsCount = 0;
  bool _isLoadingCounts = true;

  ProfileViewModel({required this.user, FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService() {
    _loadCounts();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  int get tripsCreatedCount => _tripsCreatedCount;
  int get sharedTripsCount => _sharedTripsCount;
  int get collectionsCount => _collectionsCount;
  bool get isLoadingCounts => _isLoadingCounts;

  void selectTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  Future<void> _loadCounts() async {
    try {
      _isLoadingCounts = true;
      notifyListeners();

      // Load trips created count
      final trips = await _firestoreService.getTrips(user.uid);
      _tripsCreatedCount = trips.length;

      // Load shared trips count (published posts)
      final sharedPosts = await _firestoreService.getUserPosts(user.uid);
      _sharedTripsCount = sharedPosts.length;

      // Load collections count
      final collectedPostIds = await _firestoreService.getCollectedPostIds(
        user.uid,
      );
      _collectionsCount = collectedPostIds.length;

      _isLoadingCounts = false;
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading profile counts: $e');
      _isLoadingCounts = false;
      notifyListeners();
    }
  }

  /// Refresh counts manually
  Future<void> refreshCounts() async {
    await _loadCounts();
  }
}
