import 'note_base.dart';

class LodgingNote extends NoteBase {
  final DateTime checkIn;
  final DateTime checkOut;
  final String address;

  const LodgingNote({
    required super.id,
    required super.title,
    required this.checkIn,
    required this.checkOut,
    required this.address,
    super.imageUrl,
  }) : super(type: NoteType.lodging);
}
