import 'package:tripora/features/notes/models/note_base.dart';
import 'package:tripora/features/poi/models/poi.dart';

class RestaurantNote extends NoteBase {
  final Poi poi;
  DateTime? reservationDateTime;

  RestaurantNote({
    required this.poi,
    this.reservationDateTime,
    super.userMessage,
    super.userPhotoPath,
  });
}
