import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  bool _emailTouched = false;
  bool _passwordTouched = false;

  final Color onCorrect = Colors.green;
  final Color onError = Colors.red;

  // ---- Getters ----
  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  // ---- Setters ----
  void setEmail(String value) {
    _email = value;
    _emailTouched = true;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _passwordTouched = true;
    notifyListeners();
  }

  // ---- Validation ----
  String? get emailHelperText {
    if (!_emailTouched) return null;
    if (_email.isEmpty) return 'Email cannot be empty';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(_email)) return 'Invalid email format';
    return null;
  }

  String? get passwordHelperText {
    if (!_passwordTouched) return null;
    if (_password.isEmpty) return 'Password cannot be empty';
    if (_password.length < 6) return 'Password too short';
    return null;
  }

  bool get showEmailErrorIcon => _emailTouched && emailHelperText != null;

  bool get showEmailValidIcon =>
      _emailTouched && emailHelperText == null && _email.isNotEmpty;

  bool get showPasswordErrorIcon =>
      _passwordTouched && passwordHelperText != null;

  bool get showPasswordValidIcon =>
      _passwordTouched && passwordHelperText == null && _password.isNotEmpty;

  // ---- Submit Validation ----
  bool validateAllFields() {
    _emailTouched = true;
    _passwordTouched = true;
    notifyListeners();

    return emailHelperText == null && passwordHelperText == null;
  }

  // ---- Actions ----
  Future<bool> login() async {
    final allValid = validateAllFields();
    if (!allValid) return false;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));
    final success = _email == "test@example.com" && _password == "123456";

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void forgotPassword() {
    debugPrint("Forgot password for: $_email");
  }
}
