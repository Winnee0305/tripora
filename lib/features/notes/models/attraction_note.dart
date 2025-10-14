import 'package:tripora/features/poi/models/poi.dart';

import 'note_base.dart';

class AttractionNote extends NoteBase {
  final Poi poi; // reference to your POI model

  AttractionNote({required this.poi, super.userMessage, super.userPhotoPath});
}
