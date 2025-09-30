import 'package:flutter/material.dart';

// ---------------- ViewModel ----------------
class HomeTabsViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void selectTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
