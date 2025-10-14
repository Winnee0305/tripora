import 'package:flutter/material.dart';
import '../models/note_base.dart';
import '../models/attraction_note.dart';
import '../models/lodging_note.dart';
import '../models/restaurant_note.dart';
import '../models/transportation_note.dart';
import '../models/note.dart';
import '../models/attachment_note.dart';

class NotesContentViewModel extends ChangeNotifier {
  final List<AttractionNote> attractions = [];
  final List<LodgingNote> lodgings = [];
  final List<RestaurantNote> restaurants = [];
  final List<TransportationNote> transportations = [];
  final List<Note> tickets = [];
  final List<AttachmentNote> attachments = [];

  NotesContentViewModel() {
    _loadMockData();
  }

  void _loadMockData() {
    attractions.addAll([
      AttractionNote(
        id: '1',
        title: 'Jonker Walk Melaka',
        location: 'Melaka City',
        description:
            'Night market only opens at Friday and weekend. Souvenirs and local food.',
        tags: ['Tourist Attraction', 'Popular Spot'],
        imageUrl: 'https://example.com/jonker.jpg',
      ),
      AttractionNote(
        id: '2',
        title: 'Stadthuys',
        location: 'Melaka City',
        tags: ['Museum', 'Historical Site', 'Free Entry'],
        imageUrl: 'https://example.com/stadthuys.jpg',
      ),
    ]);

    lodgings.add(
      LodgingNote(
        id: '3',
        title: 'AMES Hotel',
        address: 'Melaka, Malaysia',
        checkIn: DateTime(2025, 8, 13, 15, 0),
        checkOut: DateTime(2025, 8, 14, 12, 0),
        imageUrl: 'https://example.com/ames.jpg',
      ),
    );

    restaurants.add(
      RestaurantNote(
        id: '4',
        title: 'Peranakan Place',
        cuisine: 'Nyonya',
        reservationTime: DateTime(2025, 8, 13, 18, 0),
        imageUrl: 'https://example.com/peranakan.jpg',
      ),
    );

    transportations.add(
      TransportationNote(
        id: '5',
        title: 'KLIA',
        mode: 'Flight',
        from: 'Tokyo / HND',
        to: 'Kuala Lumpur / KUL',
        departureTime: DateTime(2025, 8, 12, 23, 30),
        arrivalTime: DateTime(2025, 8, 13, 7, 30),
        ticketNumber: 'NH885',
        imageUrl: 'https://example.com/klia.jpg',
      ),
    );

    notifyListeners();
  }

  void addNote(NoteBase note) {
    switch (note.type) {
      case NoteType.attraction:
        attractions.add(note as AttractionNote);
        break;
      case NoteType.lodging:
        lodgings.add(note as LodgingNote);
        break;
      case NoteType.restaurant:
        restaurants.add(note as RestaurantNote);
        break;
      case NoteType.transportation:
        transportations.add(note as TransportationNote);
        break;
      case NoteType.note:
        tickets.add(note as Note);
        break;
      case NoteType.attachment:
        attachments.add(note as AttachmentNote);
        break;
    }
    notifyListeners();
  }

  void removeNote(NoteBase note) {
    switch (note.type) {
      case NoteType.attraction:
        attractions.remove(note);
        break;
      case NoteType.lodging:
        lodgings.remove(note);
        break;
      case NoteType.restaurant:
        restaurants.remove(note);
        break;
      case NoteType.transportation:
        transportations.remove(note);
        break;
      case NoteType.note:
        tickets.remove(note);
        break;
      case NoteType.attachment:
        attachments.remove(note);
        break;
    }
    notifyListeners();
  }
}
