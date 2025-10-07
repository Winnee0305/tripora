class Itinerary {
  final String destination;
  final List<String> tags;
  final String image;
  final String recommendedVisitDuration;
  final String estimatedCost;

  Itinerary({
    required this.destination,
    required this.tags,
    required this.image,
    required this.recommendedVisitDuration,
    required this.estimatedCost,
  });
}
