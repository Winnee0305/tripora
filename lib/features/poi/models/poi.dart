import 'operating_hours.dart';

class Poi {
  final String name;
  final String location;
  final String description;
  final String image;
  final double rating;
  final List<OperatingHours> operatingHours; // <-- structured hours
  final String address;
  final List<String> tags;

  Poi({
    required this.name,
    required this.location,
    required this.description,
    required this.image,
    required this.rating,
    required this.operatingHours,
    required this.address,
    required this.tags,
  });
}
