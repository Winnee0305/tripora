import 'package:flutter/foundation.dart';
import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/repositories/collected_post_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class CollectsViewModel extends ChangeNotifier {
  final CollectedPostRepository _collectedPostRepo;
  final FirestoreService _firestoreService;
  final String userId;

  List<PostData> _collectedPosts = [];
  bool _isLoading = false;
  String? _error;

  // Cache user profile images to avoid redundant fetches
  final Map<String, String?> _userProfileImageCache = {};

  CollectsViewModel(
    this._collectedPostRepo,
    this._firestoreService,
    this.userId,
  ) {
    loadCollectedPosts();
  }

  List<PostData> get collectedPosts => _collectedPosts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load all collected posts for the user
  Future<void> loadCollectedPosts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get all collected post IDs
      final collectedPostIds = await _collectedPostRepo.getCollectedPostIds(
        userId,
      );
      debugPrint('📋 Found ${collectedPostIds.length} collected post IDs');

      // Fetch full post data for each collected post
      _collectedPosts = [];
      for (final postId in collectedPostIds) {
        try {
          final postData = await _firestoreService.getPost(postId);
          if (postData != null) {
            _collectedPosts.add(postData);
          }
        } catch (e) {
          debugPrint('❌ Error loading post $postId: $e');
          // Continue loading other posts even if one fails
        }
      }

      debugPrint('✅ Loaded ${_collectedPosts.length} collected posts');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load collected posts: $e';
      _isLoading = false;
      debugPrint('❌ Error loading collected posts: $e');
      notifyListeners();
    }
  }

  /// Refresh collected posts
  Future<void> refreshCollectedPosts() async {
    _userProfileImageCache.clear(); // Clear cache on refresh
    await loadCollectedPosts();
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

  /// Remove a post from collected posts (after unfavoriting)
  void removePost(String postId) {
    _collectedPosts.removeWhere((post) => post.postId == postId);
    notifyListeners();
  }
}
