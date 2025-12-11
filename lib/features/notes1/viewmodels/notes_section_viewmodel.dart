import 'package:flutter/material.dart';
import '../models/note_base.dart';

class NotesSectionViewModel extends ChangeNotifier {
  // Section title and icon
  String title;
  IconData icon;

  // Section color (affects header icon/text color)
  Color sectionColor;

  // List of notes in this section
  final List<NoteBase> notes = [];

  NotesSectionViewModel({
    required this.title,
    required this.icon,
    required this.sectionColor,
    List<NoteBase>? initialNotes,
  }) {
    if (initialNotes != null) {
      notes.addAll(initialNotes);
    }
  }

  // Add a note to this section
  void addNote(NoteBase note) {
    notes.add(note);
    notifyListeners();
  }

  // Remove a note from this section
  void removeNote(NoteBase note) {
    notes.remove(note);
    notifyListeners();
  }

  // Update section properties
  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void updateIcon(IconData newIcon) {
    icon = newIcon;
    notifyListeners();
  }

  void updateColor(Color newColor) {
    sectionColor = newColor;
    notifyListeners();
  }

  // Delete all notes (clear section)
  void clearNotes() {
    notes.clear();
    notifyListeners();
  }
}
