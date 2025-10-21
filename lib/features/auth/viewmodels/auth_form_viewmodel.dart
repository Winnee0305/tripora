import 'package:flutter/foundation.dart';

/// Base class for authentication-related form view models.
/// Handles touched state, loading state, and validation structure.
abstract class AuthFormViewModel extends ChangeNotifier {
  // ---- Shared Fields ----
  bool _isLoading = false;
  String? _authError;

  bool get isLoading => _isLoading;
  String? get authError => _authError;

  // ---- Abstract fields (to be implemented by subclasses) ----
  bool get isFormValid;
  void touchAllFields();

  // ---- Shared State Management ----
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setAuthError(String? message) {
    _authError = message;
    notifyListeners();
  }

  // ---- Helper for safe validation ----
  bool runValidationAndTouchAll() {
    touchAllFields();
    notifyListeners();
    return isFormValid;
  }

  // ---- Shared cleanup ----
  void clearAuthError() {
    if (_authError != null) {
      _authError = null;
      notifyListeners();
    }
  }
}
