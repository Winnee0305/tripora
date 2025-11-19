import 'package:flutter/material.dart';
import 'package:tripora/core/models/packing_data.dart';
import 'package:tripora/core/models/trip_data.dart';
import 'package:tripora/core/repositories/packing_repository.dart';

class PackingViewModel extends ChangeNotifier {
  final PackingRepository _packingRepo;
  bool _isLoading = false;

  PackingViewModel(this._packingRepo);

  List<PackingData> packingItems = [];

  /// REAL categories (with or without items)
  final Set<String> _categories = {};

  /// Controller for adding new items inside a category
  final Map<String, TextEditingController> newItemControllers = {};

  TripData? trip;

  // =======================
  // Getters
  // =======================
  Set<String> get categories => {
    ..._categories,
    ...packingItems.map((e) => e.category),
  };

  bool get isLoading => _isLoading;

  List<PackingData> getItemsByCategory(String category) => packingItems
      .where((e) => e.category == category && !e.isPlaceholder)
      .toList();

  int get packedItemCount => packingItems.where((item) => item.isPacked).length;

  // =======================
  // Setup
  // =======================
  void setTrip(TripData tripData) {
    trip = tripData;
  }

  Future<void> initialise() async {
    await loadPackingItems();
    for (final item in packingItems) {
      _categories.add(item.category);
    }
  }

  Future<void> loadPackingItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      packingItems = await _packingRepo.getPackingItems(trip!.tripId);

      // Ensure placeholder categories are included
      for (final cat in _categories) {
        if (!packingItems.any((item) => item.category == cat)) {
          packingItems.add(
            PackingData.empty().copyWith(category: cat, name: null),
          );
        }
      }
    } catch (e) {
      print('Failed to load packing items: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  int getTotalItems() {
    return packingItems.where((item) => !item.isPlaceholder).length;
  }

  // =======================
  // Category Handling
  // =======================
  Future<void> addCategory(String category) async {
    if (!_categories.contains(category)) {
      _categories.add(category);
      initControllersForCategory(category);

      // Add placeholder PackingData for empty category
      final placeholder = PackingData.empty().copyWith(
        category: category,
        name: null,
      );
      packingItems.add(placeholder);
      _packingRepo.addPackingItem(placeholder, trip!.tripId);

      await loadPackingItems();
      notifyListeners();
    }
  }

  Future<void> removeCategory(String category) async {
    // Find all items in this category
    final itemsToDelete = packingItems
        .where((item) => item.category == category)
        .toList();

    // Delete each item from Firestore
    for (var item in itemsToDelete) {
      if (item.id.isNotEmpty) {
        await _packingRepo.deletePackingItems(item.id, trip!.tripId);
      }
    }

    // Remove items locally
    packingItems.removeWhere((item) => item.category == category);

    // Remove controller
    newItemControllers.remove(category);

    // Remove category
    _categories.remove(category);

    // Notify UI
    notifyListeners();
  }

  Future<void> renameCategory(String oldName, String newName) async {
    // Rename all items in this category (including placeholder)
    final itemsToUpdate = packingItems
        .where((item) => item.category == oldName)
        .toList();

    for (var item in itemsToUpdate) {
      item.category = newName;

      // Update each item in Firestore

      await _packingRepo.updatePackingItem(item, trip!.tripId);
    }

    // Update controller mapping
    if (newItemControllers.containsKey(oldName)) {
      newItemControllers[newName] = newItemControllers.remove(oldName)!;
    }

    // Update _categories set
    _categories.remove(oldName);
    _categories.add(newName);

    // Notify UI to rebuild
    notifyListeners();
  }

  // =======================
  // Item Handling
  // =======================
  Future<void> addItem(String name, String category) async {
    if (!_categories.contains(category)) {
      addCategory(category);
    }
    final newItem = PackingData.empty().copyWith(
      name: name,
      category: category,
    );
    // Remove placeholder if exists
    packingItems.removeWhere(
      (item) => item.category == category && item.isPlaceholder,
    );

    packingItems.add(newItem);
    _packingRepo.addPackingItem(newItem, trip!.tripId);
    await loadPackingItems();

    notifyListeners();
  }

  void removeItem(PackingData item) {
    _packingRepo.deletePackingItems(item.id, trip!.tripId);
    packingItems.remove(item);

    notifyListeners();
  }

  void togglePacked(PackingData item) {
    item.isPacked = !item.isPacked;
    _packingRepo.updatePackingItem(item, trip!.tripId);
    notifyListeners();
  }

  // =======================
  // Controllers
  // =======================
  void initControllersForCategory(String category) {
    if (!newItemControllers.containsKey(category)) {
      newItemControllers[category] = TextEditingController();
    }
  }

  void disposeControllers() {
    for (final controller in newItemControllers.values) {
      controller.dispose();
    }
    newItemControllers.clear();
  }

  void renameItem(PackingData item, String newName) {
    item.name = newName;
    notifyListeners();
  }
}
