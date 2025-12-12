import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  final String postId;
  final String userId;
  final String tripId;
  final String tripName;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int travelersCount;
  final Map<int, List<Map<String, dynamic>>>
  itinerariesByDay; // Day number -> list of itineraries
  final List<Map<String, dynamic>> lodgings;
  final List<Map<String, dynamic>> flights;
  final DateTime lastPublished;
  final DateTime lastUpdated;

  PostData({
    required this.postId,
    required this.userId,
    required this.tripId,
    required this.tripName,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelersCount,
    required this.itinerariesByDay,
    required this.lodgings,
    required this.flights,
    required this.lastPublished,
    required this.lastUpdated,
  });

  // Convert to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tripId': tripId,
      'tripName': tripName,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'travelersCount': travelersCount,
      'itinerariesByDay': itinerariesByDay.map(
        (day, itineraries) => MapEntry(day.toString(), itineraries),
      ),
      'lodgings': lodgings,
      'flights': flights,
      'lastPublished': lastPublished.toIso8601String(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory PostData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Convert string keys back to int for itinerariesByDay
    final Map<int, List<Map<String, dynamic>>> itinerariesByDay = {};
    final rawItineraries = data['itinerariesByDay'] as Map<String, dynamic>?;
    if (rawItineraries != null) {
      rawItineraries.forEach((key, value) {
        itinerariesByDay[int.parse(key)] = List<Map<String, dynamic>>.from(
          value,
        );
      });
    }

    return PostData(
      postId: doc.id,
      userId: data['userId'] ?? '',
      tripId: data['tripId'] ?? '',
      tripName: data['tripName'] ?? '',
      destination: data['destination'] ?? '',
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
      travelersCount: data['travelersCount'] ?? 1,
      itinerariesByDay: itinerariesByDay,
      lodgings: List<Map<String, dynamic>>.from(data['lodgings'] ?? []),
      flights: List<Map<String, dynamic>>.from(data['flights'] ?? []),
      lastPublished: DateTime.parse(data['lastPublished']),
      lastUpdated: DateTime.parse(data['lastUpdated']),
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
    Map<int, List<Map<String, dynamic>>>? itinerariesByDay,
    List<Map<String, dynamic>>? lodgings,
    List<Map<String, dynamic>>? flights,
    DateTime? lastPublished,
    DateTime? lastUpdated,
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
      itinerariesByDay: itinerariesByDay ?? this.itinerariesByDay,
      lodgings: lodgings ?? this.lodgings,
      flights: flights ?? this.flights,
      lastPublished: lastPublished ?? this.lastPublished,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
