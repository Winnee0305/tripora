import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tripora/core/services/firebase_auth_service.dart';
import 'package:tripora/core/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsViewModel extends ChangeNotifier {
  bool notifications = true;
  String displayOrder = 'Newest first';
  bool hasCompletedFeedback = false;
  bool isCheckingFeedback = false;

  final FirestoreService _firestoreService = FirestoreService();

  /// Check if user has completed feedback survey and cache the result
  Future<void> checkUserFeedbackStatus(String userId) async {
    isCheckingFeedback = true;
    notifyListeners();

    try {
      hasCompletedFeedback = await _firestoreService.hasUserCompletedTAM(
        userId,
      );
      debugPrint(
        '✅ Feedback status checked: ${hasCompletedFeedback ? 'completed' : 'not completed'}',
      );
    } catch (e) {
      debugPrint('❌ Failed to check feedback status: $e');
      hasCompletedFeedback = false;
    } finally {
      isCheckingFeedback = false;
      notifyListeners();
    }
  }

  void toggleNotifications(bool v) {
    notifications = v;
    notifyListeners();
  }

  void setDisplayOrder(String order) {
    displayOrder = order;
    notifyListeners();
  }

  /// Update user profile information
  Future<void> updateUserProfile({
    required String firstname,
    required String lastname,
    required String username,
    required String gender,
    required DateTime? dateOfBirth,
    required String nationality,
  }) async {
    try {
      final currentUser = authService.value.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final updateData = <String, dynamic>{
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'lastUpdated': DateTime.now(),
      };

      // Add optional fields if provided
      if (gender.isNotEmpty) {
        updateData['gender'] = gender;
      }
      if (dateOfBirth != null) {
        updateData['dateOfBirth'] = Timestamp.fromDate(dateOfBirth);
      }
      if (nationality.isNotEmpty) {
        updateData['nationality'] = nationality;
      }

      await _firestoreService.updateUser(currentUser.uid, updateData);
      debugPrint("✅ User profile updated successfully");
    } catch (e) {
      debugPrint("❌ Failed to update user profile: $e");
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await authService.value.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint("❌ Logout failed: ${e.message}");
    }
  }
}
