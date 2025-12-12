import 'package:flutter/foundation.dart';
import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/repositories/post_repository.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class PostSectionViewmodel extends ChangeNotifier {
  final PostRepository _postRepo;
  final FirestoreService _firestoreService;

  List<PostData> _posts = [];
  bool _isLoading = false;
  String? _error;

  // Cache user profile images to avoid redundant fetches
  final Map<String, String?> _userProfileImageCache = {};

  PostSectionViewmodel(this._postRepo, this._firestoreService) {
    loadPosts();
  }

  List<PostData> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all published posts
  Future<void> loadPosts() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _posts = await _postRepo.getAllPosts(limit: 50);
      debugPrint('📋 Loaded ${_posts.length} posts');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load posts: $e';
      _isLoading = false;
      debugPrint('❌ Error loading posts: $e');
      notifyListeners();
    }
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    _userProfileImageCache.clear(); // Clear cache on refresh
    await loadPosts();
  }

  // Get user profile image URL by userId
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
}
