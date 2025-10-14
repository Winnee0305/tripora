import 'package:flutter/material.dart';
import '../../models/note_base.dart';
import '../../models/attraction_note.dart';
import '../../models/lodging_note.dart';
import '../../models/restaurant_note.dart';
import '../../models/transportation_note.dart';
import '../../models/note.dart';
import '../../models/attachment_note.dart';

class NoteCardFactory extends StatelessWidget {
  final NoteBase note;
  const NoteCardFactory({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    switch (note.type) {
      case NoteType.attraction:
        final n = note as AttractionNote;
        return ListTile(
          leading: Image.network(
            n.imageUrl ?? '',
            width: 60,
            fit: BoxFit.cover,
          ),
          title: Text(n.title),
          subtitle: Text('${n.location}\n${n.description ?? ''}'),
        );

      case NoteType.lodging:
        final n = note as LodgingNote;
        return ListTile(
          leading: Image.network(
            n.imageUrl ?? '',
            width: 60,
            fit: BoxFit.cover,
          ),
          title: Text(n.title),
          subtitle: Text(
            'Check In: ${n.checkIn.hour}:${n.checkIn.minute.toString().padLeft(2, '0')}\n'
            'Check Out: ${n.checkOut.hour}:${n.checkOut.minute.toString().padLeft(2, '0')}',
          ),
        );

      case NoteType.restaurant:
        final n = note as RestaurantNote;
        return ListTile(
          leading: Image.network(
            n.imageUrl ?? '',
            width: 60,
            fit: BoxFit.cover,
          ),
          title: Text(n.title),
          subtitle: Text('Reservation: ${n.reservationTime.hour}:00'),
        );

      case NoteType.transportation:
        final n = note as TransportationNote;
        return ListTile(
          leading: Image.network(
            n.imageUrl ?? '',
            width: 60,
            fit: BoxFit.cover,
          ),
          title: Text('${n.title} (${n.mode})'),
          subtitle: Text('${n.from} → ${n.to}\n${n.ticketNumber ?? ''}'),
        );

      case NoteType.note:
        final n = note as Note;
        return ListTile(
          title: Text(n.title),
          subtitle: Text('Note content goes here...'),
        );

      case NoteType.attachment:
        final n = note as AttachmentNote;
        return ListTile(
          title: Text(n.title),
          subtitle: Text('${n.fileName} (${n.fileType})'),
        );
    }
  }
}
