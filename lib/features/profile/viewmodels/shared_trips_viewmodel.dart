import 'package:flutter/foundation.dart';
import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class SharedTripsViewModel extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final String userId;

  List<PostData> _sharedPosts = [];
  bool _isLoading = false;
  String? _error;

  // Cache user profile images to avoid redundant fetches
  final Map<String, String?> _userProfileImageCache = {};

  SharedTripsViewModel(this._firestoreService, this.userId) {
    loadSharedPosts();
  }

  List<PostData> get sharedPosts => _sharedPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all posts published by this user
  Future<void> loadSharedPosts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get all posts by this user
      _sharedPosts = await _firestoreService.getUserPosts(userId);
      debugPrint(
        '📋 Loaded ${_sharedPosts.length} shared posts for user $userId',
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load shared trips: $e';
      _isLoading = false;
      debugPrint('❌ Error loading shared posts: $e');
      notifyListeners();
    }
  }

  /// Refresh shared posts
  Future<void> refreshSharedPosts() async {
    _userProfileImageCache.clear(); // Clear cache on refresh
    await loadSharedPosts();
  }

  /// Get user profile image URL by userId
  Future<String?> getUserProfileImage(String userId) async {
    // Check cache first
    if (_userProfileImageCache.containsKey(userId)) {
      return _userProfileImageCache[userId];
    }

    try {
      final user = await _firestoreService.getUser(userId);
      final profileImageUrl =
          (user?.profileImageUrl != null &&
              user!.profileImageUrl!.trim().isNotEmpty)
          ? user.profileImageUrl
          : null;

      // Cache the result
      _userProfileImageCache[userId] = profileImageUrl;
      return profileImageUrl;
    } catch (e) {
      debugPrint('❌ Error fetching user profile image for $userId: $e');
      _userProfileImageCache[userId] = null;
      return null;
    }
  }

  /// Remove a post from shared posts (after unpublishing)
  void removePost(String postId) {
    _sharedPosts.removeWhere((post) => post.postId == postId);
    notifyListeners();
  }
}
