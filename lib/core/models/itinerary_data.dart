import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/features/poi/models/poi.dart';

class ItineraryData {
  final String id;
  final String placeId;
  final String type; // 'destination' or 'note'
  final DateTime date;
  final String userNotes;
  final int sequence;
  final DateTime lastUpdated;
  Poi? place;

  ItineraryData({
    required this.id,
    required this.placeId,
    required this.type,
    required this.date,
    required this.userNotes,
    required this.sequence,
    required this.lastUpdated,
    this.place,
  });

  bool get isNote => type == 'note';
  bool get isDestination => type == 'destination';

  // ----- Factory from Firestore -----
  factory ItineraryData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ItineraryData(
      id: doc.id,
      placeId: data['placeId'] ?? '',
      type: data['type'] ?? 'destination',
      date: DateTime.parse(data['date']),
      userNotes: data['userNotes'] ?? '',
      sequence: int.tryParse(data['sequence'].toString()) ?? 0,
      lastUpdated: DateTime.parse(data['lastUpdated']),
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'type': type,
    'placeId': placeId,
    'date': date.toIso8601String(),
    'userNotes': userNotes,
    'sequence': sequence.toString(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  // ----- Copy With -----
  ItineraryData copyWith({
    String? id,
    String? placeId,
    String? type,
    DateTime? date,
    String? userNotes,
    int? sequence,
    double? estimatedPrice,
    double? estimatedVisitTime,
    DateTime? lastUpdated,
    Poi? place,
  }) {
    return ItineraryData(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      type: type ?? this.type,
      date: date ?? this.date,
      userNotes: userNotes ?? this.userNotes,
      sequence: sequence ?? this.sequence,
      lastUpdated: lastUpdated ?? DateTime.now(),
      place: place ?? this.place,
    );
  }

  Future<void> loadPlaceDetails() async {
    // Simulate fetching POI details from Firestore or another source
    // In a real implementation, you would fetch the data based on placeId
    place = Poi(id: placeId);
    place = await Poi.fromPlaceId(placeId);
    print("Current place intance address: ${place?.address}");
  }

  factory ItineraryData.empty(DateTime date, int sequence) {
    return ItineraryData(
      id: '',
      placeId: '',
      type: 'destination',
      date: date,
      userNotes: '',
      sequence: sequence,
      lastUpdated: DateTime.now(),
    );
  }

  factory ItineraryData.emptyNote(DateTime date, int sequence) {
    return ItineraryData(
      id: '',
      placeId: '',
      type: 'note',
      date: date,
      userNotes: '',
      sequence: sequence,
      lastUpdated: DateTime.now(),
    );
  }
}
