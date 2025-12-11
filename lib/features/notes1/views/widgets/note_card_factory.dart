import 'package:flutter/material.dart';
import '../../models/note_base.dart';
import '../../models/attraction_note.dart';
import '../../models/lodging_note.dart';
import '../../models/restaurant_note.dart';
import '../../models/transportation_note.dart';
import '../../models/user_note.dart';
import '../../models/attachment_note.dart';

class NoteCardFactory extends StatelessWidget {
  final NoteBase note;
  const NoteCardFactory({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    if (note is AttractionNote) {
      final n = note as AttractionNote;
      return ListTile(
        leading: n.userPhotoPath != null
            ? Image.network(n.userPhotoPath!, width: 60, fit: BoxFit.cover)
            : null,
        title: Text(n.poi.name),
      );
    } else if (note is LodgingNote) {
      final n = note as LodgingNote;
      String checkIn = n.checkIn != null
          ? '${n.checkIn!.hour}:${n.checkIn!.minute.toString().padLeft(2, '0')}'
          : 'N/A';
      String checkOut = n.checkOut != null
          ? '${n.checkOut!.hour}:${n.checkOut!.minute.toString().padLeft(2, '0')}'
          : 'N/A';
      return ListTile(
        leading: n.poi.imageUrl != null
            ? Image.network(n.poi.imageUrl, width: 60, fit: BoxFit.cover)
            : null,
        title: Text(n.poi.name),
        subtitle: Text('Check In: $checkIn\nCheck Out: $checkOut'),
      );
    } else if (note is RestaurantNote) {
      final n = note as RestaurantNote;
      String reservation = n.reservationDateTime != null
          ? '${n.reservationDateTime!.hour}:00'
          : 'Not set';
      return ListTile(
        leading: n.poi.imageUrl != null
            ? Image.network(n.poi.imageUrl, width: 60, fit: BoxFit.cover)
            : null,
        title: Text(n.poi.name),
        subtitle: Text('Reservation: $reservation'),
      );
    } else if (note is TransportationNote) {
      final n = note as TransportationNote;
      return ListTile(
        title: Text(n.type.toString()),
        subtitle: Text(
          '${n.departurePlace ?? ''} → ${n.arrivalPlace ?? ''}\n${n.flightNumber ?? ''}',
        ),
      );
    } else if (note is UserNote) {
      final n = note as UserNote;
      return ListTile(
        leading: Text("testing"),
        title: Text(n.userMessage ?? 'User Note'),
        subtitle: Text(n.userMessage ?? 'No additional note'),
      );
    } else if (note is AttachmentNote) {
      final n = note as AttachmentNote;
      return ListTile(
        title: Text(n.userMessage ?? 'Attachment'),
        subtitle: Text('${n.pdfPath}'),
      );
    } else {
      return const ListTile(title: Text('Unknown Note'));
    }
  }
}
