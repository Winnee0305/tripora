// models/nearby_attraction.dart
import 'package:tripora/features/poi/models/poi.dart';

class NearbyAttraction {
  Poi poi;
  double distanceMeters;

  NearbyAttraction({required this.poi, required this.distanceMeters});
}
