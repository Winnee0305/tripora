import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/services/firebase_auth_service.dart';
import 'package:tripora/core/utils/auth_validators.dart';
import 'package:tripora/features/auth/viewmodels/auth_form_viewmodel.dart';

class LoginViewModel extends AuthFormViewModel {
  String _email = '';
  String _password = '';
  bool _touchedEmail = false;
  bool _touchedPassword = false;

  // ---- Getters ----
  String get email => _email;
  String get password => _password;

  // ---- Setters ----
  void setEmail(String value) {
    _email = value.trim();
    _touchedEmail = true;
    clearAuthError();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _touchedPassword = true;
    clearAuthError();
    notifyListeners();
  }

  // ---- Validation ----
  String? get emailMessage =>
      _touchedEmail ? AuthValidators.validateEmail(_email) : null;
  String? get passwordMessage =>
      _touchedPassword ? AuthValidators.validatePassword(_password) : null;

  bool get isEmailValid => _touchedEmail && AuthValidators.isEmailValid(_email);
  bool get isPasswordValid =>
      _touchedPassword && AuthValidators.isPasswordValid(_password);

  @override
  bool get isFormValid =>
      AuthValidators.isEmailValid(_email) &&
      AuthValidators.isPasswordValid(_password);

  @override
  void touchAllFields() {
    _touchedEmail = true;
    _touchedPassword = true;
  }

  // ---- Actions ----
  Future<bool> submitLogin() async {
    final allValid = runValidationAndTouchAll();
    if (!allValid) {
      debugPrint("⚠️ Invalid form");
      return false;
    }

    setLoading(true);
    setAuthError(null);

    try {
      await authService.value.signIn(email: _email, password: _password);
      debugPrint("✅ Login successful");
      return true;
    } on FirebaseAuthException catch (e) {
      setAuthError(e.message ?? "Login failed. Please try again.");
      debugPrint("❌ FirebaseAuthException: ${e.code} — ${e.message}");
      return false;
    } catch (e) {
      setAuthError("An unexpected error occurred. Please try again.");
      debugPrint("❌ Unknown login error: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> forgotPassword() async {
    if (!AuthValidators.isEmailValid(_email)) {
      setAuthError("Please enter a valid email before resetting password.");
      return;
    }

    try {
      await authService.value.resetPassword(email: _email);
      debugPrint("📧 Password reset email sent to $_email");
    } catch (e) {
      setAuthError("Failed to send reset email. Try again later.");
    }
  }

  String get generalErrorMessage {
    return "The email address or password you entered is incorrect. Please try again.";
  }
}
