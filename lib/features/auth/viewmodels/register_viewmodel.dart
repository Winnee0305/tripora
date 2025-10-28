import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/services/firebase_auth_service.dart';
import 'package:tripora/core/utils/auth_validators.dart';
import 'package:tripora/features/auth/viewmodels/auth_form_viewmodel.dart';

class RegisterViewModel extends AuthFormViewModel {
  String _firstname = '';
  String _lastname = '';
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  bool _touchedFirstName = false;
  bool _touchedLastName = false;
  bool _touchedUsername = false;
  bool _touchedEmail = false;
  bool _touchedPassword = false;
  bool _touchedConfirm = false;

  // ---- Setters ----
  void setFirstName(String value) {
    _firstname = value.trim();
    _touchedFirstName = true;
    clearAuthError();
    notifyListeners();
  }

  void setLastName(String value) {
    _lastname = value.trim();
    _touchedLastName = true;
    clearAuthError();
    notifyListeners();
  }

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
  String? get firstnameMessage =>
      _touchedFirstName ? AuthValidators.validateFirstName(_firstname) : null;
  String? get lastnameMessage =>
      _touchedLastName ? AuthValidators.validateLastName(_lastname) : null;
  String? get usernameMessage =>
      _touchedUsername ? AuthValidators.validateUsername(_username) : null;
  String? get emailMessage =>
      _touchedEmail ? AuthValidators.validateEmail(_email) : null;
  String? get passwordMessage =>
      _touchedPassword ? AuthValidators.validatePassword(_password) : null;
  String? get confirmPasswordMessage => _touchedConfirm
      ? AuthValidators.validateConfirmPassword(_password, _confirmPassword)
      : null;

  bool get isFirstNameValid =>
      _touchedFirstName && AuthValidators.isFirstNameValid(_firstname);
  bool get isLastNameValid =>
      _touchedLastName && AuthValidators.isLastNameValid(_lastname);
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
      AuthValidators.isFirstNameValid(_firstname) &&
      AuthValidators.isLastNameValid(_lastname) &&
      AuthValidators.isUsernameValid(_username) &&
      AuthValidators.isEmailValid(_email) &&
      AuthValidators.isPasswordValid(_password) &&
      AuthValidators.isConfirmPasswordValid(_password, _confirmPassword);

  @override
  void touchAllFields() {
    _touchedFirstName = true;
    _touchedLastName = true;
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
      // 🔹 Check username uniqueness in Firestore
      final isUnique = await authService.value.isUsernameUnique(_username);
      if (!isUnique) {
        setAuthError("Username already taken. Please choose another one.");
        debugPrint("⚠️ Username '$_username' is already used.");
        return false;
      }

      // Create Firebase Auth account
      final userCredential = await authService.value.createAccount(
        email: _email,
        password: _password,
      );
      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception("User UID not found after registration");

      // Update display name in Firebase Auth
      await authService.value.updateUsername(username: _username);

      // Create Firestore user record
      await authService.value.createUserRecord(
        uid: uid,
        firstname: _firstname,
        lastname: _lastname,
        username: _username,
        email: _email,
      );

      debugPrint("✅ Registration success for user: $_username");
      await authService.value.signIn(email: _email, password: _password);
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
