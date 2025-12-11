import 'package:cloud_firestore/cloud_firestore.dart';

class NoteData {
  final String id;
  final String note;
  final DateTime date;
  final int sequence;
  final DateTime lastUpdated;

  NoteData({
    required this.id,
    required this.note,
    required this.date,
    required this.sequence,
    required this.lastUpdated,
  });

  // ----- Factory from Firestore -----
  factory NoteData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return NoteData(
      id: doc.id,
      note: data['note'] ?? '',
      date: DateTime.parse(data['date']),
      sequence: int.tryParse(data['sequence'].toString()) ?? 0,
      lastUpdated: DateTime.parse(data['lastUpdated']),
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'note': note,
    'date': date.toIso8601String(),
    'sequence': sequence.toString(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  // ----- Copy With -----
  NoteData copyWith({
    String? id,
    String? note,
    DateTime? date,
    int? sequence,
    DateTime? lastUpdated,
  }) {
    return NoteData(
      id: id ?? this.id,
      note: note ?? this.note,
      date: date ?? this.date,
      sequence: sequence ?? this.sequence,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  // ----- Empty constructor -----
  factory NoteData.empty(DateTime date, int sequence) {
    return NoteData(
      id: '',
      note: '',
      date: date,
      sequence: sequence,
      lastUpdated: DateTime.now(),
    );
  }
}
