import 'package:cloud_firestore/cloud_firestore.dart';

class PoiHistoryData {
  final String id;
  final String placeId;
  final String poiName;
  final String address;
  final List<String> tags;
  final DateTime viewedAt;

  PoiHistoryData({
    required this.id,
    required this.placeId,
    required this.poiName,
    required this.address,
    required this.tags,
    required this.viewedAt,
  });

  // ---- Factory from Firestore ----
  factory PoiHistoryData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PoiHistoryData(
      id: doc.id,
      placeId: data['placeId'] ?? '',
      poiName: data['poiName'] ?? '',
      address: data['address'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      viewedAt: (data['viewedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // ---- To Firestore ----
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'poiName': poiName,
      'address': address,
      'tags': tags,
      'viewedAt': Timestamp.fromDate(viewedAt),
    };
  }

  // ---- Copy with ----
  PoiHistoryData copyWith({
    String? id,
    String? placeId,
    String? poiName,
    String? address,
    List<String>? tags,
    DateTime? viewedAt,
  }) {
    return PoiHistoryData(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      poiName: poiName ?? this.poiName,
      address: address ?? this.address,
      tags: tags ?? this.tags,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }
}
