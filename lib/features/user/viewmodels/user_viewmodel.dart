import 'package:flutter/material.dart';
import 'package:tripora/features/user/models/user_data.dart';
import 'package:tripora/core/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepo;
  UserData? _user;
  bool isLoading = false;

  UserViewModel(this._userRepo);

  Future<void> loadUser() async {
    if (_userRepo.idUidEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      _user = await _userRepo.getUserProfile();
      debugPrint("✅ User loaded: ${_user?.firstname} ${_user?.lastname}");
    } catch (e) {
      debugPrint("❌ Failed to load user: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  UserData? get user => _user;

  // Future<void> updateProfilePicture(String imagePath) async {
  //   image = imagePath;

  //   notifyListeners();
  // }
}
