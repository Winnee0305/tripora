import 'package:tripora/core/services/firebase_firestore_service.dart';

class CollectedPostRepository {
  final FirestoreService _firestoreService;

  CollectedPostRepository(this._firestoreService);

  /// Add a post to user's collected posts
  Future<void> addToCollection(String uid, String postId) async {
    await _firestoreService.addToCollectedPosts(uid, postId);
  }

  /// Remove a post from user's collected posts
  Future<void> removeFromCollection(String uid, String postId) async {
    await _firestoreService.removeFromCollectedPosts(uid, postId);
  }

  /// Check if a post is in user's collection
  Future<bool> isCollected(String uid, String postId) async {
    return await _firestoreService.isPostCollected(uid, postId);
  }

  /// Get all collected post IDs for a user
  Future<List<String>> getCollectedPostIds(String uid) async {
    return await _firestoreService.getCollectedPostIds(uid);
  }

  /// Toggle collection status (add if not collected, remove if collected)
  Future<bool> toggleCollection(String uid, String postId) async {
    final isCollected = await this.isCollected(uid, postId);
    if (isCollected) {
      await removeFromCollection(uid, postId);
      return false; // Now not collected
    } else {
      await addToCollection(uid, postId);
      return true; // Now collected
    }
  }
}
