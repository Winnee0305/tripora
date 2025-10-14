import 'note_base.dart';

class AttractionNote extends NoteBase {
  final String location;
  final String? description;
  final List<String>? tags;
  final String? openDays;
  final String? entryFee;

  const AttractionNote({
    required super.id,
    required super.title,
    required this.location,
    this.description,
    this.tags,
    this.openDays,
    this.entryFee,
    super.imageUrl,
  }) : super(type: NoteType.attraction);
}
