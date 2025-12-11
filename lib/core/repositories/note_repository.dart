import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tripora/core/models/note_data.dart';

class NoteRepository {
  final FirebaseFirestore _firestore;
  final String _uid;

  NoteRepository(this._firestore, this._uid);

  // Fetch all notes for a trip
  Future<List<NoteData>> fetchNotes(String tripId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc('data')
          .collection('notes')
          .get();

      return snapshot.docs.map((doc) => NoteData.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  // Add a new note
  Future<String> addNote(String tripId, NoteData note) async {
    try {
      final noteId = (note.id.isNotEmpty)
          ? note.id
          : _firestore
                .collection('users')
                .doc(_uid)
                .collection('trips')
                .doc(tripId)
                .collection('itineraries')
                .doc('data')
                .collection('notes')
                .doc()
                .id;

      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc('data')
          .collection('notes')
          .doc(noteId)
          .set(note.copyWith(id: noteId).toMap(), SetOptions(merge: true));

      return noteId;
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  // Update an existing note
  Future<void> updateNote(String tripId, NoteData note) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc('data')
          .collection('notes')
          .doc(note.id)
          .update(note.toMap());
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // Delete a note
  Future<void> deleteNote(String tripId, String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_uid)
          .collection('trips')
          .doc(tripId)
          .collection('itineraries')
          .doc('data')
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  // Stream notes for real-time updates
  Stream<List<NoteData>> streamNotes(String tripId) {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('trips')
        .doc(tripId)
        .collection('itineraries')
        .doc('data')
        .collection('notes')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => NoteData.fromFirestore(doc)).toList(),
        );
  }
}
