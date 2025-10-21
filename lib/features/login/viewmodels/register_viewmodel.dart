import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/services/auth_service.dart';
import '../models/login_request.dart';

class RegisterViewModel extends ChangeNotifier {
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _isLoading = false;
  String? _authError; // 👈 Add this

  bool _touchedUsername = false;
  bool _touchedEmail = false;
  bool _touchedPassword = false;
  bool _touchedConfirm = false;

  // ---- Getters ----
  String get username => _username;
  String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  bool get isLoading => _isLoading;
  String? get authError => _authError;

  // ---- Validation Messages ----
  String? get usernameMessage {
    if (!_touchedUsername) return null;
    if (_username.isEmpty) return 'Username cannot be empty';
    if (_username.length < 3) return 'Username must be at least 3 characters';
    return 'Username looks good';
  }

  String? get emailMessage {
    if (!_touchedEmail) return null;
    if (_email.isEmpty) return 'Email cannot be empty';
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(_email)) return 'Invalid email format';
    return 'Email looks good';
  }

  String? get passwordMessage {
    if (!_touchedPassword) return null;
    if (_password.isEmpty) return 'Password cannot be empty';
    if (_password.length < 6) return 'Password must be at least 6 characters';
    return 'Password is strong';
  }

  String? get confirmPasswordMessage {
    if (!_touchedConfirm) return null;
    if (_confirmPassword.isEmpty) return 'Please confirm your password';
    if (_confirmPassword != _password) return 'Passwords do not match';
    return 'Passwords match';
  }

  // ---- Validation States ----
  bool get isUsernameValid => usernameMessage == 'Username looks good';
  bool get isEmailValid => emailMessage == 'Email looks good';
  bool get isPasswordValid => passwordMessage == 'Password is strong';
  bool get isConfirmValid => confirmPasswordMessage == 'Passwords match';

  bool get isUsernameError =>
      _touchedUsername && !isUsernameValid && usernameMessage != null;
  bool get isEmailError =>
      _touchedEmail && !isEmailValid && emailMessage != null;
  bool get isPasswordError =>
      _touchedPassword && !isPasswordValid && passwordMessage != null;
  bool get isConfirmError =>
      _touchedConfirm && !isConfirmValid && confirmPasswordMessage != null;

  bool get isFormValid =>
      isUsernameValid && isEmailValid && isPasswordValid && isConfirmValid;

  // ---- Setters ----
  void setUsername(String value) {
    _username = value;
    _touchedUsername = true;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _touchedEmail = true;
    _authError = null; //
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _touchedPassword = true;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _touchedConfirm = true;
    notifyListeners();
  }

  // ---- Trigger All Field Validation ----
  void _touchAllFields() {
    _touchedUsername = true;
    _touchedEmail = true;
    _touchedPassword = true;
    _touchedConfirm = true;
  }

  // ---- Register Action ----
  Future<void> submitRegister() async {
    _touchAllFields(); // Mark all as touched first
    notifyListeners();

    if (!isFormValid) {
      debugPrint("⚠️ Form invalid, please fix errors before submitting.");
      return;
    }

    _isLoading = true;
    notifyListeners();

    register();

    // try {
    //   await Future.delayed(const Duration(seconds: 2));
    //   final request = LoginRequest(email: _email, password: _password);
    //   debugPrint("✅ Registering user: ${request.email}");
    //   // TODO: integrate API here
    // } catch (e) {
    //   debugPrint("❌ Registration failed: $e");
    // } finally {
    //   _isLoading = false;
    //   notifyListeners();
    // }
  }

  Future<void> register() async {
    try {
      await authService.value.createAccount(email: _email, password: _password);

      _isLoading = false;
      _authError = null; // ✅ Clear error when success
      notifyListeners();

      debugPrint("✅ Registration success");
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _authError =
          e.message ?? "Registration failed. Please try again."; // 👈 Set error
      notifyListeners();

      debugPrint("❌ FirebaseAuthException: ${e.code} — ${e.message}");
    } catch (e) {
      _isLoading = false;
      _authError = "An unexpected error occurred. Please try again.";
      notifyListeners();

      debugPrint("❌ Unknown registration error: $e");
    }
  }
}
