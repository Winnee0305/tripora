import 'package:flutter/material.dart';
import 'package:tripora/features/user/models/user_data.dart';
import 'package:tripora/features/exploration/models/travel_post.dart';

class ProfileViewModel extends ChangeNotifier {
  late UserData user;

  List<Post> collects = [];

  ProfileViewModel({required this.user});

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void selectTab(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
