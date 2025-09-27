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

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    final request = LoginRequest(email: _email, password: _password);
    debugPrint("Login attempted with: ${request.email}, ${request.password}");

    _isLoading = false;
    notifyListeners();
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
