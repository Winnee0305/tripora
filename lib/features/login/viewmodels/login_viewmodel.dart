import 'package:flutter/foundation.dart';
import '../models/login_request.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  /// Returns true if login successful
  Future<bool> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 2)); // simulate API call
      final request = LoginRequest(email: _email, password: _password);
      debugPrint("Logging in with: ${request.email}, ${request.password}");

      // TODO: call your auth API and check success
      return true; // assume success
    } catch (e) {
      debugPrint("Login failed: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void forgotPassword() {
    debugPrint("Forgot password for email: $_email");
  }
}
