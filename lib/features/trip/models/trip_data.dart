import 'package:cloud_firestore/cloud_firestore.dart';

class TripData {
  final String tripId;
  final String tripName;
  final DateTime? startDate;
  final DateTime? endDate;
  final String destination;
  final String travelStyle;
  final String travelPartnerType;
  final int travelersCount;
  final String? tripImageUrl;
  final String? tripStoragePath;
  final DateTime? lastUpdated;

  TripData({
    required this.tripId,
    required this.tripName,
    this.startDate,
    this.endDate,
    required this.destination,
    required this.travelStyle,
    required this.travelPartnerType,
    required this.travelersCount,
    this.tripImageUrl,
    this.tripStoragePath,
    this.lastUpdated,
  });

  // -----  Factory from Firestore -----
  factory TripData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripData(
      tripId: doc.id,
      tripName: data['tripName'],
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
      destination: data['destination'],
      travelStyle: data['travelStyle'],
      travelPartnerType: data['travelPartnerType'],
      travelersCount: data['travelersCount'],
      tripImageUrl: data['tripImageUrl'],
      tripStoragePath: data['tripStoragePath'],
      lastUpdated: data['lastUpdated'] != null
          ? DateTime.parse(data['lastUpdated'])
          : null,
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'tripId': tripId,
    'tripName': tripName,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'destination': destination,
    'travelStyle': travelStyle,
    'travelPartnerType': travelPartnerType,
    'travelersCount': travelersCount,
    'tripImageUrl': tripImageUrl,
    'tripStoragePath': tripStoragePath,
    'lastUpdated': DateTime.now().toIso8601String(),
  };

  // ----- Copy With -----
  TripData copyWith({
    String? tripId,
    String? tripName,
    DateTime? startDate,
    DateTime? endDate,
    String? destination,
    String? travelStyle,
    String? travelPartnerType,
    int? travelersCount,
    String? tripImageUrl,
    String? tripStoragePath,
    DateTime? lastUpdated,
  }) {
    return TripData(
      tripId: tripId ?? this.tripId,
      tripName: tripName ?? this.tripName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      destination: destination ?? this.destination,
      travelStyle: travelStyle ?? this.travelStyle,
      travelPartnerType: travelPartnerType ?? this.travelPartnerType,
      travelersCount: travelersCount ?? this.travelersCount,
      tripImageUrl: tripImageUrl ?? this.tripImageUrl,
      tripStoragePath: tripStoragePath ?? this.tripStoragePath,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // ----- Empty TripData -----
  factory TripData.empty() {
    return TripData(
      tripId: '',
      tripName: '',
      startDate: null,
      endDate: null,
      destination: '',
      travelStyle: '',
      travelPartnerType: '',
      travelersCount: 0,
      tripImageUrl: '',
      tripStoragePath: '',
      lastUpdated: DateTime.now(),
    );
  }
}
