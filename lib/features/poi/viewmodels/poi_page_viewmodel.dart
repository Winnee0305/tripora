import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:tripora/core/services/ai_agents_service.dart';
import '../models/poi.dart';

class PoiPageViewmodel extends ChangeNotifier {
  Poi? poi;
  bool isLoading = true;

  PoiPageViewmodel(String placeId) {
    _init(placeId);
  }

  Future<void> _init(String placeId) async {
    try {
      poi = await Poi.fromPlaceId(placeId);
    } catch (e) {
      if (kDebugMode) print("Error loading POI: $e");
      poi = Poi(id: placeId); // fallback
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
