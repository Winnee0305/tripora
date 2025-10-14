import 'package:tripora/features/notes/models/note_base.dart';

enum TransportType { flight, train, bus, other }

class TransportationNote extends NoteBase {
  final TransportType type;
  String? flightNumber; // only for flight
  String? departurePlace;
  String? arrivalPlace;
  DateTime? departureTime;
  DateTime? arrivalTime;

  TransportationNote({
    required this.type,
    this.flightNumber,
    this.departurePlace,
    this.arrivalPlace,
    this.departureTime,
    this.arrivalTime,
    super.userMessage,
    super.userPhotoPath,
  });
}
