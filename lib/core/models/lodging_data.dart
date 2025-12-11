import 'package:cloud_firestore/cloud_firestore.dart';

class LodgingData {
  final String id;
  final String name;
  final String placeId;
  final DateTime date;
  final DateTime checkInDateTime;
  final DateTime checkOutDateTime;
  final int sequence;
  final DateTime lastUpdated;

  LodgingData({
    required this.id,
    required this.name,
    required this.placeId,
    required this.date,
    required this.checkInDateTime,
    required this.checkOutDateTime,
    required this.sequence,
    required this.lastUpdated,
  });

  // ----- Factory from Firestore -----
  factory LodgingData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LodgingData(
      id: doc.id,
      name: data['name'] ?? '',
      placeId: data['placeId'] ?? '',
      date: DateTime.parse(data['date']),
      checkInDateTime: DateTime.parse(data['checkInDateTime']),
      checkOutDateTime: DateTime.parse(data['checkOutDateTime']),
      sequence: int.tryParse(data['sequence'].toString()) ?? 0,
      lastUpdated: DateTime.parse(data['lastUpdated']),
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'type': 'lodging',
    'name': name,
    'placeId': placeId,
    'date': date.toIso8601String(),
    'checkInDateTime': checkInDateTime.toIso8601String(),
    'checkOutDateTime': checkOutDateTime.toIso8601String(),
    'sequence': sequence.toString(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  // ----- Copy With -----
  LodgingData copyWith({
    String? id,
    String? name,
    String? placeId,
    DateTime? date,
    DateTime? checkInDateTime,
    DateTime? checkOutDateTime,
    int? sequence,
    DateTime? lastUpdated,
  }) {
    return LodgingData(
      id: id ?? this.id,
      name: name ?? this.name,
      placeId: placeId ?? this.placeId,
      date: date ?? this.date,
      checkInDateTime: checkInDateTime ?? this.checkInDateTime,
      checkOutDateTime: checkOutDateTime ?? this.checkOutDateTime,
      sequence: sequence ?? this.sequence,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  // ----- Empty constructor -----
  factory LodgingData.empty(DateTime date, int sequence) {
    return LodgingData(
      id: '',
      name: '',
      placeId: '',
      date: date,
      checkInDateTime: DateTime(
        date.year,
        date.month,
        date.day,
        15,
        0,
      ), // Default 3 PM
      checkOutDateTime: DateTime(
        date.year,
        date.month,
        date.day + 1,
        11,
        0,
      ), // Default 11 AM next day
      sequence: sequence,
      lastUpdated: DateTime.now(),
    );
  }
}
