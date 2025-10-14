import 'note_base.dart';

class Note extends NoteBase {
  const Note({required super.id, required super.title})
    : super(type: NoteType.note);
}
