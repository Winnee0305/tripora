import 'package:tripora/features/notes/models/note_base.dart';
import 'package:tripora/features/poi/models/poi.dart';

class LodgingNote extends NoteBase {
  final Poi poi;
  DateTime? checkIn;
  DateTime? checkOut;

  LodgingNote({
    required this.poi,
    this.checkIn,
    this.checkOut,
    super.userMessage,
    super.userPhotoPath,
  });
}
