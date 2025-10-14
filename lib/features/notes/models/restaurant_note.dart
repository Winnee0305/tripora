import 'note_base.dart';

class RestaurantNote extends NoteBase {
  final DateTime reservationTime;
  final String cuisine;
  final bool isReservationRequired;

  const RestaurantNote({
    required super.id,
    required super.title,
    required this.reservationTime,
    required this.cuisine,
    this.isReservationRequired = false,
    super.imageUrl,
  }) : super(type: NoteType.restaurant);
}
