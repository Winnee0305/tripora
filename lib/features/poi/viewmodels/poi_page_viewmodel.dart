import 'package:flutter/foundation.dart';
import 'package:tripora/features/poi/models/poi.dart';

class PoiPageViewmodel extends ChangeNotifier {
  Poi? poi;
  bool isLoading = true;

  PoiPageViewmodel(String placeId) {
    _init(placeId);
  }

  Future<void> _init(String placeId) async {
    try {
      // Load POI details immediately
      poi = await Poi.fromPlaceId(placeId);
    } catch (e) {
      if (kDebugMode) print("Error loading POI: $e");
      poi = Poi(id: placeId); // fallback
    } finally {
      isLoading = false;
      notifyListeners(); // rebuild UI with POI info
    }

    // Fetch AI description separately, after init
    if (poi != null) {
      poi!.loadDesc().then((_) {
        notifyListeners(); // rebuild UI when description is ready
      });
      poi!.loadNearbyAttractions().then((_) {
        notifyListeners(); // rebuild UI when nearby attractions are ready
      });
    }
  }
}
