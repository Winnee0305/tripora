import 'package:cloud_firestore/cloud_firestore.dart';

class FlightData {
  final String id;
  final String flightNumber;
  final String airline;
  final String departureAirport;
  final String arrivalAirport;
  final DateTime departureDateTime;
  final DateTime arrivalDateTime;
  final DateTime date;
  final int sequence;
  final DateTime lastUpdated;

  FlightData({
    required this.id,
    required this.flightNumber,
    required this.airline,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.departureDateTime,
    required this.arrivalDateTime,
    required this.date,
    required this.sequence,
    required this.lastUpdated,
  });

  // ----- Factory from Firestore -----
  factory FlightData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FlightData(
      id: doc.id,
      flightNumber: data['flightNumber'] ?? '',
      airline: data['airline'] ?? '',
      departureAirport: data['departureAirport'] ?? '',
      arrivalAirport: data['arrivalAirport'] ?? '',
      departureDateTime: DateTime.parse(data['departureDateTime']),
      arrivalDateTime: DateTime.parse(data['arrivalDateTime']),
      date: DateTime.parse(data['date']),
      sequence: int.tryParse(data['sequence'].toString()) ?? 0,
      lastUpdated: DateTime.parse(data['lastUpdated']),
    );
  }

  // ----- To Firestore -----
  Map<String, dynamic> toMap() => {
    'flightNumber': flightNumber,
    'airline': airline,
    'departureAirport': departureAirport,
    'arrivalAirport': arrivalAirport,
    'departureDateTime': departureDateTime.toIso8601String(),
    'arrivalDateTime': arrivalDateTime.toIso8601String(),
    'date': date.toIso8601String(),
    'sequence': sequence.toString(),
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  // ----- Copy With -----
  FlightData copyWith({
    String? id,
    String? flightNumber,
    String? airline,
    String? departureAirport,
    String? arrivalAirport,
    DateTime? departureDateTime,
    DateTime? arrivalDateTime,
    DateTime? date,
    int? sequence,
    DateTime? lastUpdated,
  }) {
    return FlightData(
      id: id ?? this.id,
      flightNumber: flightNumber ?? this.flightNumber,
      airline: airline ?? this.airline,
      departureAirport: departureAirport ?? this.departureAirport,
      arrivalAirport: arrivalAirport ?? this.arrivalAirport,
      departureDateTime: departureDateTime ?? this.departureDateTime,
      arrivalDateTime: arrivalDateTime ?? this.arrivalDateTime,
      date: date ?? this.date,
      sequence: sequence ?? this.sequence,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  // ----- Empty constructor -----
  factory FlightData.empty(DateTime date, int sequence) {
    return FlightData(
      id: '',
      flightNumber: '',
      airline: '',
      departureAirport: '',
      arrivalAirport: '',
      departureDateTime: DateTime(date.year, date.month, date.day, 8, 0),
      arrivalDateTime: DateTime(date.year, date.month, date.day, 10, 0),
      date: date,
      sequence: sequence,
      lastUpdated: DateTime.now(),
    );
  }
}
