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
  String _gender = ''; // 'male', 'female', 'other'
  DateTime? _dateOfBirth;
  String _nationality = ''; // ISO 3166-1 alpha-2 country code

  bool _touchedFirstName = false;
  bool _touchedLastName = false;
  bool _touchedUsername = false;
  bool _touchedEmail = false;
  bool _touchedPassword = false;
  bool _touchedConfirm = false;
  bool _touchedGender = false;
  bool _touchedDateOfBirth = false;
  bool _touchedNationality = false;

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

  void setGender(String value) {
    _gender = value;
    _touchedGender = true;
    clearAuthError();
    notifyListeners();
  }

  void setDateOfBirth(DateTime? value) {
    _dateOfBirth = value;
    _touchedDateOfBirth = true;
    clearAuthError();
    notifyListeners();
  }

  void setNationality(String value) {
    _nationality = value;
    _touchedNationality = true;
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
  String? get genderMessage =>
      _touchedGender ? AuthValidators.validateGender(_gender) : null;
  String? get dateOfBirthMessage => _touchedDateOfBirth
      ? AuthValidators.validateDateOfBirth(_dateOfBirth)
      : null;
  String? get nationalityMessage => _touchedNationality
      ? AuthValidators.validateNationality(_nationality)
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
  bool get isGenderValid =>
      _touchedGender && AuthValidators.isGenderValid(_gender);
  bool get isDateOfBirthValid =>
      _touchedDateOfBirth && AuthValidators.isDateOfBirthValid(_dateOfBirth);
  bool get isNationalityValid =>
      _touchedNationality && AuthValidators.isNationalityValid(_nationality);

  // Getters for UI access
  String get gender => _gender;
  DateTime? get dateOfBirth => _dateOfBirth;
  String get nationality => _nationality;

  @override
  bool get isFormValid =>
      AuthValidators.isFirstNameValid(_firstname) &&
      AuthValidators.isLastNameValid(_lastname) &&
      AuthValidators.isUsernameValid(_username) &&
      AuthValidators.isEmailValid(_email) &&
      AuthValidators.isPasswordValid(_password) &&
      AuthValidators.isConfirmPasswordValid(_password, _confirmPassword) &&
      AuthValidators.isGenderValid(_gender) &&
      AuthValidators.isDateOfBirthValid(_dateOfBirth) &&
      AuthValidators.isNationalityValid(_nationality);

  @override
  void touchAllFields() {
    _touchedFirstName = true;
    _touchedLastName = true;
    _touchedUsername = true;
    _touchedEmail = true;
    _touchedPassword = true;
    _touchedConfirm = true;
    _touchedGender = true;
    _touchedDateOfBirth = true;
    _touchedNationality = true;
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
        gender: _gender,
        dateOfBirth: _dateOfBirth,
        nationality: _nationality,
      );

      // Wait for Firestore to propagate the document
      await Future.delayed(const Duration(milliseconds: 500));

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
