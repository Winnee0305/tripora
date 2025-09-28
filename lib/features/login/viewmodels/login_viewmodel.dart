import 'package:flutter/foundation.dart';
import '../models/login_request.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false; // <-- not final so it can change

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

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Example async work
      await Future.delayed(const Duration(seconds: 2));

      final request = LoginRequest(email: _email, password: _password);
      debugPrint("Logging in with: ${request.email}, ${request.password}");

      // TODO: Call your API/auth service here
    } catch (e) {
      debugPrint("Login failed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void forgotPassword() {
    debugPrint("Forgot password for email: $_email");
    // Normally would trigger navigation or API call
  }

  void register() {
    debugPrint("Navigate to registration page");
    // Normally would trigger navigation
  }
}
