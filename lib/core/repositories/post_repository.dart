import 'package:tripora/core/models/post_data.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';

class PostRepository {
  final FirestoreService _firestoreService;
  final String _uid;

  PostRepository(this._firestoreService, this._uid);

  // Getter for userId
  String get userId => _uid;

  // Create or update a post
  Future<String> publishPost(PostData post) async {
    return await _firestoreService.publishPost(_uid, post);
  }

  // Get a specific post by ID
  Future<PostData?> getPost(String postId) async {
    return await _firestoreService.getPost(postId);
  }

  // Get all posts by a user
  Future<List<PostData>> getUserPosts(String userId) async {
    return await _firestoreService.getUserPosts(userId);
  }

  // Delete a post
  Future<void> deletePost(String postId) async {
    await _firestoreService.deletePost(postId);
  }

  // Check if trip has been published
  Future<PostData?> getPostByTripId(String tripId) async {
    return await _firestoreService.getPostByTripId(_uid, tripId);
  }

  // Get all posts for public feed
  Future<List<PostData>> getAllPosts({int limit = 50}) async {
    return await _firestoreService.getAllPosts(limit: limit);
  }

  // Mark post as orphaned when trip is deleted
  Future<void> markPostAsOrphaned(String postId) async {
    await _firestoreService.markPostAsOrphaned(postId);
  }

  // Unpublish a post
  Future<void> unpublishPost(String postId, String? tripId) async {
    await _firestoreService.unpublishPost(postId, tripId);
  }
}
