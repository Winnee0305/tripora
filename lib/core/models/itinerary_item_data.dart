import 'package:cloud_firestore/cloud_firestore.dart';

class ItineraryItemData {
  final String id;
  final String location;
  final DateTime date;
  final String notes;
  final String? image;
  final int sequence;

  ItineraryItemData({
    required this.id,
    required this.location,
    required this.date,
    required this.notes,
    this.image,
    required this.sequence,
  });

  // ----- Factory from Firestore -----
  factory ItineraryItemData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItineraryItemData(
      id: doc.id,
      location: data['location'],
      date: DateTime.parse(data['date']),
      notes: data['notes'],
      image: data['image'],
      sequence: data['sequence'],
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'location': location,
    'date': date.toIso8601String(),
    'notes': notes,
    'image': image,
    'sequence': sequence,
  };
}
