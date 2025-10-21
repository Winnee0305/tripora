import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/services/auth_service.dart';
import 'package:tripora/core/utils/auth_validators.dart';
import 'package:tripora/features/auth/viewmodels/auth_form_viewmodel.dart';

class RegisterViewModel extends AuthFormViewModel {
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _touchedUsername = false;
  bool _touchedEmail = false;
  bool _touchedPassword = false;
  bool _touchedConfirm = false;

  // ---- Setters ----
  void setUsername(String value) {
    _username = value.trim();
    _touchedUsername = true;
    clearAuthError();
    notifyListeners();
  }

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

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    _touchedConfirm = true;
    clearAuthError();
    notifyListeners();
  }

  // ---- Validation ----
  String? get usernameMessage =>
      _touchedUsername ? AuthValidators.validateUsername(_username) : null;
  String? get emailMessage =>
      _touchedEmail ? AuthValidators.validateEmail(_email) : null;
  String? get passwordMessage =>
      _touchedPassword ? AuthValidators.validatePassword(_password) : null;
  String? get confirmPasswordMessage => _touchedConfirm
      ? AuthValidators.validateConfirmPassword(_password, _confirmPassword)
      : null;

  bool get isUsernameValid =>
      _touchedUsername && AuthValidators.isUsernameValid(_username);
  bool get isEmailValid => _touchedEmail && AuthValidators.isEmailValid(_email);
  bool get isPasswordValid =>
      _touchedPassword && AuthValidators.isPasswordValid(_password);
  bool get isConfirmValid =>
      _touchedConfirm &&
      AuthValidators.isConfirmPasswordValid(_password, _confirmPassword);

  @override
  bool get isFormValid =>
      AuthValidators.isUsernameValid(_username) &&
      AuthValidators.isEmailValid(_email) &&
      AuthValidators.isPasswordValid(_password) &&
      AuthValidators.isConfirmPasswordValid(_password, _confirmPassword);

  @override
  void touchAllFields() {
    _touchedUsername = true;
    _touchedEmail = true;
    _touchedPassword = true;
    _touchedConfirm = true;
  }

  // ---- Register ----
  Future<bool> submitRegister() async {
    final allValid = runValidationAndTouchAll();
    if (!allValid) return false;

    setLoading(true);
    setAuthError(null);

    try {
      await authService.value.createAccount(email: _email, password: _password);
      await authService.value.updateUsername(username: _username);
      debugPrint("✅ Registration success");
      return true;
    } on FirebaseAuthException catch (e) {
      setAuthError(e.message ?? "Registration failed. Please try again.");
      debugPrint("❌ FirebaseAuthException: ${e.code} — ${e.message}");
      return false;
    } catch (e) {
      setAuthError("An unexpected error occurred. Please try again.");
      debugPrint("❌ Unknown registration error: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }
}
