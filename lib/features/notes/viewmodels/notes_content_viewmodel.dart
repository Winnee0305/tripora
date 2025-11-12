import 'package:flutter/material.dart';
import 'package:tripora/features/poi/models/operating_hours.dart';
import 'package:tripora/features/poi/models/poi.dart';
import 'package:tripora/features/poi/viewmodels/poi_page_viewmodel.dart';
import '../models/note_base.dart';
import '../models/attraction_note.dart';
import '../models/lodging_note.dart';
import '../models/restaurant_note.dart';
import '../models/transportation_note.dart';
import '../models/user_note.dart';
import '../models/attachment_note.dart';

class NotesContentViewModel extends ChangeNotifier {
  final List<AttractionNote> attractions = [];
  final List<LodgingNote> lodgings = [];
  final List<RestaurantNote> restaurants = [];
  final List<TransportationNote> transportations = [];
  final List<UserNote> tickets = [];
  final List<AttachmentNote> attachments = [];

  late final Map<Type, List<NoteBase>> _noteMap;

  NotesContentViewModel() {
    // Initialize the map
    _noteMap = {
      AttractionNote: attractions,
      LodgingNote: lodgings,
      RestaurantNote: restaurants,
      TransportationNote: transportations,
      UserNote: tickets,
      AttachmentNote: attachments,
    };

    // _loadMockData();
  }

  // void _loadMockData() {
  //   attractions.addAll([AttractionNote(poi: PoiPageViewmodel().place)]);

  //   attractions.addAll([
  //     AttractionNote(
  //       poi: PoiPageViewmodel().place,
  //       userMessage: 'Great place!',
  //     ),
  //   ]);

  //   lodgings.addAll([
  //     LodgingNote(
  //       poi: Poi(
  //         name: 'Ames Hotel',
  //         description: 'A nice hotel in the city center.',
  //         location: '123 Main St, Cityville',
  //         image: 'assets/images/hotel.png',
  //         rating: 4.5,
  //         operatingHours: [
  //           OperatingHours(day: "Monday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Tuesday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Wednesday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Thursday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Friday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Saturday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Sunday", open: "09:00", close: "17:30"),
  //         ],
  //         address: "31, Jalan Laksamana, Banda Hilir, 75000 Melaka",
  //         tags: ["Historical", "Museum", "Architecture"],
  //       ),
  //       checkIn: DateTime(2025, 8, 13, 14, 0),
  //       checkOut: DateTime(2025, 8, 14, 12, 0),
  //     ),
  //   ]);

  //   restaurants.add(
  //     RestaurantNote(
  //       poi: Poi(
  //         name: 'Peranakan Place',
  //         description: '',
  //         location: '123 Main St, Cityville',
  //         image: 'assets/images/hotel.png',
  //         rating: 4.5,
  //         operatingHours: [
  //           OperatingHours(day: "Monday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Tuesday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Wednesday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Thursday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Friday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Saturday", open: "09:00", close: "17:30"),
  //           OperatingHours(day: "Sunday", open: "09:00", close: "17:30"),
  //         ],
  //         address: "31, Jalan Laksamana, Banda Hilir, 75000 Melaka",
  //         tags: ["Historical", "Museum", "Architecture"],
  //       ),
  //     ),
  //   );

  //   transportations.add(TransportationNote(type: TransportType.flight));

  //   notifyListeners();
  // }

  void addNote(NoteBase note) {
    final list = _noteMap[note.runtimeType];
    if (list == null) throw Exception("Unknown note type: ${note.runtimeType}");
    list.add(note);
    notifyListeners();
  }

  void removeNote(NoteBase note) {
    final list = _noteMap[note.runtimeType];
    if (list == null) throw Exception("Unknown note type: ${note.runtimeType}");
    list.remove(note);
    notifyListeners();
  }
}
