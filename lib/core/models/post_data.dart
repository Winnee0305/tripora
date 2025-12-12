import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final String postId;
  final String userId;
  final String? tripId; // Optional - null if trip was deleted
  final String tripName;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int travelersCount;
  final String? tripImageUrl; // For display in posts
  final String userName; // User's display name
  final String? userImageUrl; // User's profile image
  // Note: itineraries, lodgings, and flights are now stored as subcollections
  final DateTime lastPublished;
  final DateTime lastUpdated;
  final bool tripDeleted; // Flag indicating if source trip was deleted

  PostData({
    required this.postId,
    required this.userId,
    this.tripId,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelersCount,
    this.tripImageUrl,
    required this.userName,
    this.userImageUrl,
    required this.lastPublished,
    required this.lastUpdated,
    this.tripDeleted = false,
  });

  // Convert to Firestore map (subcollections are stored separately)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tripId': tripId,
      'tripName': tripName,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'travelersCount': travelersCount,
      'tripImageUrl': tripImageUrl,
      'userName': userName,
      'userImageUrl': userImageUrl,
      'lastPublished': lastPublished.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
      'tripDeleted': tripDeleted,
    };
  }

  // Create from Firestore document (subcollections are fetched separately)
  factory PostData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PostData(
      postId: doc.id,
      userId: data['userId'] ?? '',
      tripId: data['tripId'],
      tripName: data['tripName'] ?? '',
      destination: data['destination'] ?? '',
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
      travelersCount: data['travelersCount'] ?? 1,
      tripImageUrl: data['tripImageUrl'],
      userName: data['userName'] ?? 'Unknown User',
      userImageUrl: data['userImageUrl'],
      lastPublished: DateTime.parse(data['lastPublished']),
      lastUpdated: DateTime.parse(data['lastUpdated']),
      tripDeleted: data['tripDeleted'] ?? false,
    );
  }

  PostData copyWith({
    String? postId,
    String? userId,
    String? tripId,
    String? tripName,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    int? travelersCount,
    String? tripImageUrl,
    String? userName,
    String? userImageUrl,
    DateTime? lastPublished,
    DateTime? lastUpdated,
    bool? tripDeleted,
  }) {
    return PostData(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      tripId: tripId ?? this.tripId,
      tripName: tripName ?? this.tripName,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelersCount: travelersCount ?? this.travelersCount,
      tripImageUrl: tripImageUrl ?? this.tripImageUrl,
      userName: userName ?? this.userName,
      userImageUrl: userImageUrl ?? this.userImageUrl,
      lastPublished: lastPublished ?? this.lastPublished,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      tripDeleted: tripDeleted ?? this.tripDeleted,
    );
  }
}
