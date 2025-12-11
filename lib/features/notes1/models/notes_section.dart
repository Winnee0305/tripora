import 'dart:ui';

import 'package:tripora/features/notes/models/note_base.dart';

abstract class NotesSection {
  // List of notes belonging to this section
  List<NoteBase> notes = [];

  // Color for section (affects icon color)
  final Color sectionColor;

  NotesSection({required this.sectionColor});

  // Optional: method to add a note
  void addNote(NoteBase note) {
    notes.add(note);
  }
}
