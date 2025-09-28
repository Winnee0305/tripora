import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// ===========================
/// VIEWMODEL
/// ===========================
class HomeViewModel extends ChangeNotifier {
  int _selectedIndex = 0;
  int _currentIndex = 0;

  int get selectedIndex => _selectedIndex;
  int get currentIndex => _currentIndex;

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void updateIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
