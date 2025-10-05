// Trip model (simplified)
class Trip {
  final String id;
  final String title;
  final String location;
  final DateTime start;
  final DateTime end;
  final String image;
  final int notesCount;
  final double expense;
  final int itineraryCount;
  final int packingCount;
  final int attachments;
  final List<String> tags;

  Trip({
    required this.id,
    required this.title,
    required this.location,
    required this.start,
    required this.end,
    required this.image,
    this.notesCount = 0,
    this.expense = 0,
    this.itineraryCount = 0,
    this.packingCount = 0,
    this.attachments = 0,
    this.tags = const [],
  });
}
