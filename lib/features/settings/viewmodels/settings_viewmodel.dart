import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  bool notifications = true;
  String displayOrder = 'Newest first';

  void toggleNotifications(bool v) {
    notifications = v;
    notifyListeners();
  }

  void setDisplayOrder(String order) {
    displayOrder = order;
    notifyListeners();
  }
}
