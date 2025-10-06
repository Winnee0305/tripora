import 'package:flutter/material.dart';

class NavigationViewModel extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  // Handles tab switch logic
  void onTabSelected(int index) {
    if (index == _currentIndex) return;
    _currentIndex = index;
    notifyListeners();
  }

  // Optional: route management (if using Navigator)
  String get currentRoute {
    switch (_currentIndex) {
      case 0:
        return '/home';
      case 1:
        return '/chat';
      case 2:
        return '/trip';
      case 3:
        return '/profile';
      default:
        return '/home';
    }
  }
}
