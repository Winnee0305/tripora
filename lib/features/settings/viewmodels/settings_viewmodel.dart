import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/services/auth_service.dart';

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

  Future<void> logout() async {
    try {
      await authService.value.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ Logout failed: ${e.message}");
    }
  }
}
