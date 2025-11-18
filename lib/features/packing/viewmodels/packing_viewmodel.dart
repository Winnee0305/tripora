import 'package:flutter/material.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/repositories/packing_repository.dart';
import 'package:tripora/core/services/smart_packing_service.dart';
import '../models/packing_item.dart';

class PackingViewModel extends ChangeNotifier {
  final PackingRepository _packingRepo;

  PackingViewModel(this._packingRepo) {}

  final List<PackingItem> _items = SmartPackingService()
      .getMockMelakaTripList();
  final Map<String, TextEditingController> newItemControllers = {};
  List<PackingItem> get items => _items;
  Set<String> get categories => _items.map((e) => e.category).toSet();
  TripData? trip;

  setTrip(TripData tripData) {
    trip = tripData;
  }

  void initialise() {}

  void togglePacked(PackingItem item) {
    item.isPacked = !item.isPacked;
    notifyListeners();
  }

  void addItem(String name, String category) {
    _items.add(PackingItem(name: name, category: category));
    notifyListeners();
  }

  void removeItem(PackingItem item) {
    _items.remove(item);
    notifyListeners();
  }

  List<PackingItem> getItemsByCategory(String category) =>
      _items.where((e) => e.category == category).toList();

  int get packedItemCount => _items.where((item) => item.isPacked).length;

  void removeCategory(String category) {
    _items.removeWhere((item) => item.category == category);
    newItemControllers.remove(category); // cleanup controller
    notifyListeners();
  }

  void initControllersForCategory(String category) {
    if (!newItemControllers.containsKey(category)) {
      newItemControllers[category] = TextEditingController();
    }
  }

  void disposeControllers() {
    for (final c in newItemControllers.values) {
      c.dispose();
    }
    newItemControllers.clear();
  }
}
