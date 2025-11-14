import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tripora/core/reusable_widgets/app_toast.dart';
import 'package:tripora/core/models/user_data.dart';
import 'package:tripora/core/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepo;
  UserData? _user;
  String? toastMessage;

  bool isLoading = false; // for full profile data
  bool isImageLoading = false; // for image fetch/precache

  ImageProvider _profileImage = const AssetImage("assets/logo/tripora.JPG");

  UserViewModel(this._userRepo);

  ImageProvider get profileImage => _profileImage;

  UserData? get user => _user;

  /// Loads the user profile and triggers image preloading separately
  Future<void> loadUser(BuildContext context) async {
    if (_userRepo.idUidEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      _user = await _userRepo.getUserProfile();
      debugPrint("✅ User loaded: ${_user?.firstname} ${_user?.lastname}");

      // Start image loading separately
      await _loadProfileImage(context);
    } catch (e) {
      debugPrint("❌ Failed to load user: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  /// Loads and precaches the profile image
  Future<void> _loadProfileImage(BuildContext context) async {
    final url = _user?.profileImageUrl;

    isImageLoading = true;
    notifyListeners();

    try {
      if (url != null && url.isNotEmpty) {
        final networkImage = NetworkImage(url);
        await precacheImage(networkImage, context);
        _profileImage = networkImage;
      } else {
        _profileImage = const AssetImage("assets/logo/tripora.JPG");
      }
    } catch (e) {
      debugPrint("❌ Failed to load profile image: $e");
      _profileImage = const AssetImage("assets/logo/tripora.JPG");
    }

    isImageLoading = false;
    notifyListeners();
  }

  /// Updates profile picture and reloads the image only (not the whole user)
  Future<void> updateProfilePicture(
    String imagePath,
    BuildContext context,
  ) async {
    if (imagePath.isEmpty) return;

    isImageLoading = true;
    notifyListeners();

    toastMessage = "Uploading image...";

    try {
      final file = File(imagePath);

      // Upload and update Firestore
      final downloadUrl = await _userRepo.uploadProfileImage(
        file: file,
        onProgress: (progress) {
          debugPrint(
            '📤 Upload progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
        },
      );

      if (downloadUrl != null) {
        _user = _user?.copyWith(profileImageUrl: downloadUrl);
        _profileImage = NetworkImage(downloadUrl);
        await precacheImage(_profileImage, context);

        toastMessage = "Profile picture updated!";
      }
    } catch (e) {
      debugPrint("sFailed to update profile image: $e");

      toastMessage = "Failed to update profile picture.";
    }

    isImageLoading = false;
    notifyListeners();

    // Reload user data to sync with DB
    loadUser(context);
  }
}
