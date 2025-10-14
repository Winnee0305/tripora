import 'note_base.dart';

class TransportationNote extends NoteBase {
  final String from;
  final String to;
  final String mode; // e.g., Flight, Train, Bus
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String? ticketNumber;

  const TransportationNote({
    required super.id,
    required super.title,
    required this.from,
    required this.to,
    required this.mode,
    required this.departureTime,
    required this.arrivalTime,
    this.ticketNumber,
    super.imageUrl,
  }) : super(type: NoteType.transportation);
}
