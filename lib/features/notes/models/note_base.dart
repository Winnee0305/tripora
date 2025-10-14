enum NoteType {
  attraction,
  lodging,
  restaurant,
  transportation,
  note,
  attachment,
}

abstract class NoteBase {
  final String id;
  final String title;
  final String? imageUrl;
  final NoteType type;

  const NoteBase({
    required this.id,
    required this.title,
    required this.type,
    this.imageUrl,
  });
}
